# Multithreading
Multiple threads shares the same code but run on different register and stack 
Good for IO bound processes 
Interleave task on he same processor 
Python GIL thread prevents true parallel processing

# Multiprocessing
More overhead compared to multithreading 
Does not share the same heap due to GIL lock \