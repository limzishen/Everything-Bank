## Context

Heap-access instrumentation is one of the AST transformers pray runs at import time
(`src/pray_ast/ast_parser/heap_access_instrumentation.py`,
`HeapAccessInstrumentationTransformer`). 

Its job is to wrap every **read or write of a shared heap object** with scheduler hooks and a **yield point**, so the cooperative scheduler is allowed to context-switch at the exact places where a data race couldoccur. 

It does *not* detect races — it only plants the switch points that let a
scheduling policy (`rand`/`pos`/`pct`/…) drive threads into the racy interleaving until
the program's own `assert` fails or the run deadlocks.

"Heap object" here means a mutable object reached through a **subscript** (`x[i]`) or an
**attribute** (`obj.attr`) — lists, dicts, and user-class instances. The benchmark
convention of boxing shared state as `x = [0]` and mutating via `x[0]` exists precisely
so this transformer can see the access.

> ⚠️ **Limitation:** only heap-like targets are instrumented. Bare local/`global`/
> `nonlocal` name bindings (`x = 1`) are **not** — there is no subscript/attribute to
> hook (`heap_access_instrumentation.py:28-30`).

---

## The shape it injects

Every instrumented access expands to the same four-part sandwich:

```
register_heap_variable_<kind>(obj)     # pre  — tell scheduler "about to touch obj"
_pray.yield_point(...)                 # the actual context-switch opportunity
<original access>                      # node — the read/write itself
deregister_heap_variable_<kind>(obj)   # post — "done touching obj"
```

- `kind` is `read` or `write`.
- The hooks are built by `_make_heap_access_hooks` (`:96`) and the yield by
  `_yield_call`; the pair passed around everywhere is `(obj_expr, obj_src)` —
  `obj_expr` is a deep-copied AST node evaluating to the *base object*, `obj_src` is its
  `ast.unparse` string for logging (e.g. `"x[0]"`).

---

## What gets instrumented (the visitor methods)

| AST node                                             | Method                     | Trigger                                              | kind                |
| ---------------------------------------------------- | -------------------------- | ---------------------------------------------------- | ------------------- |
| `obj.append(...)`, `pop`, `insert`, `__setitem__`, … | `visit_Expr` (`:123`)      | call whose method ∈ `OBJECT_MUTATING_METHODS` (`:6`) | write               |
| `obj.get(...)`, `copy`, `index`, `__getitem__`, …    | `visit_Expr` (`:123`)      | method ∈ `OBJECT_READING_METHODS` (`:19`)            | read                |
| `x[i] = v`, `obj.attr = v`                           | `visit_Assign` (`:167`)    | Store-context Subscript/Attribute targets            | write               |
| `del x[i]`, `del obj.attr`                           | `visit_Delete` (`:209`)    | Del-context Subscript/Attribute                      | write               |
| `x[i] += v`, `obj.attr += v`                         | `visit_AugAssign` (`:259`) | Subscript/Attribute target                           | read **then** write |

Targets are gathered by `_collect_heap_write_accesses` (`:62`) / `_collect_heap_read_accesses`
(`:80`), which recurse into tuple/list unpacking targets (`a[i], b[j] = ...`). Note:
`visit_Assign` only hooks the **write targets** on the left-hand side — plain reads on
the RHS (`y = x[0]`) are not wrapped by `visit_Assign` itself; reads become yield points
mainly through `visit_AugAssign` and the reading-method calls.

For multi-target statements the pres are emitted in order and the posts in **reversed**
order (`:192`, `:236`), so the register/deregister calls nest cleanly around the access.

---

## The interesting case: `visit_AugAssign` (`:259`)

`x[i] += v` is a read-modify-write — the classic lost-update site — so it is desugared
into an explicit read phase and write phase, **each with its own yield point**, so the
scheduler can interleave *between* the read and the write:

```python
# arr[i] += rhs   becomes (conceptually):
__pray_base = arr                 # eval base once
__pray_idx  = i                   # eval index once
register_heap_variable_read(__pray_base)
_pray.yield_point("Before Heap Read: arr[i]")      # <-- switch point #1
__pray_old = __pray_base[__pray_idx]
deregister_heap_variable_read(__pray_base)

__pray_rhs = rhs
__pray_new = __pray_old + __pray_rhs

register_heap_variable_write(__pray_base)
_pray.yield_point("Before Heap Write: arr[i]")     # <-- switch point #2
__pray_base[__pray_idx] = __pray_new
deregister_heap_variable_write(__pray_base)
```

Base and index are evaluated **once** into temporaries (`__pray_base_heap_variable`,
`__pray_write_idx`) so side-effecting subscripts aren't re-run. The window between switch
point #1 and #2 is exactly what makes `benchmark/mp_pipe_lost_update_bad.py` (and the
other RMW bugs) reproducible: two threads both read the old value, then clobber each
other's write.

---

## How it connects to the scheduler

- `register/deregister_heap_variable_read/write` land on `BaseScheduler`
  (`scheduler/scheduler_base.py:325-340`). Plain schedulers ignore the payload; POS/PCT
  override them to gather the metadata that biases `ready.get()` toward reordering
  racing accesses.
- `_pray.yield_point(...)` is the real hand-off: it calls `__yield_point`
  (`scheduler_base.py:436`), which picks the next thread via `ready.get()` and
  context-switches. If no thread is runnable but some are blocked → `Deadlock`
  (`:465-472`).

So heap instrumentation supplies the **switch points**; the scheduler supplies the
**decision**; the program's `assert` (or a deadlock) supplies the **oracle**.

---

## Quick verification

`pray run <file> --sched rand --dry-run` prints the transformed AST — the
`register_heap_variable_*` / `yield_point` sandwich around each shared access is visible
inline. See also [[pray-ast fails on native blockingIO]] for the flip side: native C
blocking calls contain *no* instrumented access, so the token never hands off.
