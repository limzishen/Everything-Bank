**Data types & mutability**

- Mutable: `list`, `dict`, `set`. Immutable: `int`, `str`, `tuple`, `frozenset`. This matters for function arguments (mutable defaults are a classic trap) and dict keys (must be hashable/immutable).

**Mutable default argument trap**

```python
def f(x, acc=[]):  # BUG: acc persists across calls
    acc.append(x); return acc
# Fix: acc=None, then acc = acc or []
```

**`is` vs `==`**  
`==` compares value, `is` compares identity (same object). Never use `is` for value checks except `is None`.

**Shallow vs deep copy**  
`b = a` (reference), `a.copy()` (shallow — nested objects still shared), `copy.deepcopy(a)` (fully independent).

**Comprehensions**

```python
[x**2 for x in range(10) if x % 2 == 0]
{k: v for k, v in pairs}
```

**Generators / `yield`** — lazy evaluation, memory-efficient for large sequences. Understand the difference between `[]` (list, eager) and `()` (generator, lazy).

```Python 
def count_up_to(max_val):
    count = 1
    while count <= max_val:
        yield count
        count += 1

# Calling the function returns a generator object—it does not run the code yet!
counter = count_up_to(3)

# You can grab values manually using next()
print(next(counter))  # Output: 1
print(next(counter))  # Output: 2
print(next(counter))  # Output: 3

# Calling next() again raises a StopIteration exception because the generator is exhausted
```

**lazy evaluation** 
```python 
# List comprehension (Loads everything into memory immediately) 
squares_list = [x**2 for x in range(1000000)]
# Generator expression (Computes each square on demand) 
squares_gen = (x**2 for x in range(1000000)) 
print(next(squares_gen)) 
# Output: 0 print(next(squares_gen)) # Output: 1
```

**`*args` / `**kwargs`** — variadic positional/keyword args.

**Decorators** — functions wrapping functions; know `@wraps` and a basic timer/logging example.
```Python 
def my_decorator(func):
    def wrapper():
        print("1. Action before the function runs.")
        func()
        print("2. Action after the function runs.")
    return wrapper

@my_decorator
def say_hello():
    print("   Hello, World!")

say_hello()
# prints 1. Action before the function runs. Hello, World! 2. Action after the function runs.
```
**Common built-ins** — `enumerate`, `zip`, `map`, `filter`, `sorted(key=...)`, `any`/`all`.

```Python 
numbers = [1, 2, 3, 4] 
# Using a lambda (anonymous) function to square each item 
squared_numbers = list(map(lambda x: x**2, numbers))
odd = list(filter(lambda xL x%2== 1, numbers))

truth = [False, False, True]
print(any(truth)) # prints True 
print(all(truth)) # prints False
```
**Dict/set operations** — O(1) average lookup vs O(n) for list membership. Interviewers probe this.

**String handling** 
immutability, `.join()` over `+=` in loops, 
```Python 
# BAD: O(n²) — each += creates a new string, copying everything
result = ""
for w in words:
    result += w

# GOOD: O(n) — single allocation
result = "".join(words)
```
f-strings, slicing `s[::-1]`.
**Scope & closures** — LEGB rule, `global`/`nonlocal`.
```Python
count = 0
def inc():
    global count
    count += 1
```

```Python 
def counter():
    n = 0
    def inc():
        nonlocal n   # without this: UnboundLocalError
        n += 1
        return n
    return inc
```
**Exception handling** — `try/except/else/finally`, catching specific exceptions not bare `except`.

**Truthiness** — empty containers, `0`, `""`, `None` are falsy.

**Context manager** - a wrapper to open/close file or lock acquiring 
To **automatically allocate and release resources** exactly when needed, preventing bugs like resource leaks or file corruption

Without context manager
```Python 
# Old/Manual approach
file = open("data.txt", "w")
try:
    file.write("Hello World")
finally:
    file.close()  # Guaranteed to run, but code is bulky

```

With context manager 
```Python 
# Modern approach using 'with'
with open("data.txt", "w") as file:
    file.write("Hello World")  # File closes automatically when you exit this block
```