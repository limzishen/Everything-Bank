Everything in python is a heap allocated object (PyObject)

# PyObject 
```C
typedef struct {
    Py_ssize_t ob_refcnt;    // reference count (the memory model)
    PyTypeObject *ob_type;   // pointer to this object's type
} PyObject;
```

# PyFrameObject
```C
struct _frame {
    PyObject_HEAD              // <- the PyObject header, expanded inline
    struct _frame *f_back;     // caller frame (the call-stack link)
    PyInterpreterFrame *f_frame; // the actual execution state
    int f_lineno;
    ...                        // (locals view, trace flags, etc.)
};
```


# Heap Types vs Static Types

## Static types
Static types are types `int`/`str`/`list`/`type`/`object` that are tagged during runtime 
Faster as the typing is already baked into the C binary 

## Heap types 
User created types that are allocated into the heap during runtime

# GC 
The PyObject stores the reference counter, when the reference counter hits 0, the object is removed from the heap. 

## Cyclic garbage collector 
A garbage collector that run periodically and focus on objects that are containers 

**Generation 0: _Newly allocated container objects._**

**Generation 1: _Objects that survived one collection._**

**Generation 2: _Long lived survivors that survived multiple rounds._**


