---
tags: [ai-edited]
---
Fork creates a child process which a duplicate of the original process
```
int pid = fork();

if (pid > 0) {
    // I am the PARENT process
    // My 'pid' variable holds my child's ID.
    // In the parent process this will run
    wait(NULL); // I can wait for my child to finish.
} else if (pid == 0) {
    // I am the CHILD process
    // Child process will run this segment of code 
    // My 'pid' variable is 0.
} else {
    // Fork FAILED
}
```

# Copy-on-write
`fork()` doesn't copy memory eagerly. Parent and child share physical pages marked read-only, and a page is copied only when one side writes to it. That makes `fork()` cheap and is why Redis can snapshot with it ([[Redis]]).

# fork + exec + wait
```c
pid_t pid = fork();
if (pid == 0) { execvp(argv[0], argv); _exit(127); }  // child: replace image
waitpid(pid, &status, 0);                             // parent: reap (else zombie)
```
- `exec*` replaces the process image, keeping the PID and open fds (unless `O_CLOEXEC`).
- Not reaping a child leaves a **zombie**. If the parent dies first, the child is an **orphan** and gets re-parented to init.

# Gotcha: fork in a multithreaded process
Only the calling thread survives in the child. Locks held by other threads stay locked forever, so the child should only call async-signal-safe functions before `exec`. This is why Python 3.14 moved the default start method off `fork` on Linux, and why Pray has to care about start methods ([[Pray Notes]], [[Pray Research Diary - 2 Aug 2026]]).

# Related
- [[Process]] · [[Thread]] · [[Python Multiprocessing vs Multithreading]]
