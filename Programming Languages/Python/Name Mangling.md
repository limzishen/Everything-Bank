---
tags: [ai-edited]
---
In Cpython/symtable.c 

Name mangling is implemented to prevent accidental naming conflict in classes during inheritance. Cpython automatically renames the variable internally to avoid clashes

## Accessing Mangled Names

```Python
class Student:
    def __init__(self, name):
        self.__name = name

    def show(self):
        print(self.__name)

s = Student("Jake")
s.show()
print(s.__name) 
# Unable to access __name as the variable is internally mangled 
```

```Python 
# Access it through specifiying 
class Student:
     def __init__(self, name):
         self.__name = name

s = Student("Jake")
print(s._Student__name)

```


## Safe Method Overriding 
Prevents the parent method from being accidentally overridden. `Parent.__init__` calls `self.__show`, which is mangled to `self._Parent__show`, so it always resolves to the parent's version even when `Child` defines `show`.
```Python 
class Parent:
    def __init__(self):
       self.__show()

    def show(self):
       print("Parent class")

    __show = show

class Child(Parent):
     def show(self):
        print("Child class")

obj = Child()
obj.show()

# output: 
# Parent class
# Child class
```

Without mangling, the child override hijacks the parent's internal call (output: `Child class` twice):
```Python 
class Parent:
    def __init__(self):
       self.show()

    def show(self):
       print("Parent class")


class Child(Parent):
     def show(self):
        print("Child class")

obj = Child()
obj.show()
```

# Related
- [[Python Execution Model]]
