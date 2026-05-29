 Bug 1 — The main thread is never registered

  test/deadlock_test.py has no main() or run() function. All code is at module level. The EntrypointBootstrapTransformer only injects
  _pray.register_thread() into a named function; since there is no such function, the main thread is never registered. That means:

  - events[main_tid] does not exist
  - the main thread is never in ready



```
  __yield_point when the main thread calls block_on_object:

  # scheduler_base.py:458
  if tid in self.events and next_tid is not None and next_tid != tid:
      # … suspend this thread
      self._suspend_thread(tid)
  else:
      self.lock.release()   # ← main always takes this branch


```

  Because main_tid not in self.events, the main thread never suspends. It releases the scheduler lock and immediately spins back into CoopLock.acquire's
  while True: loop, calling block_on_object over and over.

  Bug 2 — CoopLock.acquire ignores the timeout parameter

  CoopThread.join is supposed to be a bounded poll loop:

  # coop_thread.py:76-83
  while True:
      if self._scheduler.is_cancelled():
          …
      if event.wait(0.01):   # intended: "try for 0.01 s, then re-check"
          break

  event.wait(0.01) → threading.Event.wait(0.01) → CoopCondition.wait(0.01) → waiter.acquire(True, 0.01). But CoopLock.acquire is:

  # coop_lock.py:15-29
  def acquire(self, blocking: bool = True, timeout: float = -1):
      tid = threading.get_ident()
      while True:
          if not self._locked:
              …
              return True
          if not blocking:
              return False
          self._waiters.add(tid)
          self._scheduler.block_on_object(self)   # timeout is never used!

  The timeout argument is accepted but silently ignored. So event.wait(0.01) never times out — it either returns True (event set) or blocks indefinitely
  (calling block_on_object repeatedly without ever returning False).

  How the two bugs combine into an infinite loop

  1. Both workers start and park (waiting on their scheduler events).
  2. Main calls t1.join(timeout=2) → enters CoopThread.join's while True: → calls event.wait(0.01) → calls block_on_object(waiter).
  3. block_on_object calls __yield_point. __yield_point selects a worker, sets its event, but main never suspends (Bug 1). Main releases the scheduler lock
   and loops immediately.
  4. Workers get their events set and start running concurrently with main (cooperative scheduling is broken). Because time.sleep(0.1) is not a yield
  point, the workers may both run far enough to cross-acquire the two locks — locking in the classic AB / BA order.
  5. When each worker calls block_on_object on the other's lock, it IS removed from ready and added to blocked. But main is spinning in the background 
  calling block_on_object and __yield_point in a tight loop. Every time main calls __yield_point while at least one worker is still in ready (executing),
  The timeout argument is accepted but silently ignored. So event.wait(0.01) never times out — it either returns True (event set) or blocks indefinitely
  (calling block_on_object repeatedly without ever returning False).

  How the two bugs combine into an infinite loop

  6. Both workers start and park (waiting on their scheduler events).
  7. Main calls t1.join(timeout=2) → enters CoopThread.join's while True: → calls event.wait(0.01) → calls block_on_object(waiter).
  8. block_on_object calls __yield_point. __yield_point selects a worker, sets its event, but main never suspends (Bug 1). Main releases the scheduler lock
   and loops immediately.
  9. Workers get their events set and start running concurrently with main (cooperative scheduling is broken). Because time.sleep(0.1) is not a yield
  point, the workers may both run far enough to cross-acquire the two locks — locking in the classic AB / BA order.
  10. When each worker calls block_on_object on the other's lock, it IS removed from ready and added to blocked. But main is spinning in the background
  calling block_on_object and __yield_point in a tight loop. Every time main calls __yield_point while at least one worker is still in ready (executing),
  next_tid is non-None, so the deadlock condition next_tid is None and self.blocked is never true at any single call.
  11. Because event.wait(0.01) never returns False (Bug 2), and is_cancelled() never becomes True (deadlock wasn't detected), the outer while True: in
  CoopThread.join runs forever — the timeout argument 2 was discarded on entry.

  ---
  The fix

  Two things need to change:

  12. test/deadlock_test.py needs a main() function so that EntrypointBootstrapTransformer can register the main thread and bring it under cooperative
  scheduling control.
  13. CoopLock.acquire must honour the timeout argument — or CoopThread.join must fall back to a real threading.Event for the poll interval so the 0.01 s
  timeout actually works as a wall-clock limit.
