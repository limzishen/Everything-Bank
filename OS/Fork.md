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