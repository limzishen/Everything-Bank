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
Prevents the parent methoc
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
