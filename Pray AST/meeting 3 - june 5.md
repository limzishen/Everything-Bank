This is a Python 3.14-specific circular import bug. Let me look at the root cause.

  Read 2 files

The root cause is a circular import specific to Python 3.14. In 3.14, ast.unparse() lazily imports _ast_unparse the first time it's called. When pray's metapath finder is installed, it intercepts that lazy import and tries to instrument _ast_unparse.py, which calls ast.unparse() again — but _ast_unparse is still mid-initialization, so it deadlocks into an ImportError.

The fix: pre-warm ast.unparse at module load time in _utils.py, before any finder is ever installed, so _ast_unparse is already in sys.modules.

small fix 

# Causation 
In Python ≤ 3.13, the _Unparser class that powers ast.unparse() was defined directly inside ast.py. Importing ast made it immediately available.

In Python 3.14, it was moved to a separate module _ast_unparse.py and imported lazily inside the function body — only on the first call to ast.unparse():


```
def unparse(ast_obj):
    global _Unparser
    try:
        unparser = _Unparser()
    except NameError:
        from _ast_unparse import Unparser as _Unparser
        unparser = _Unparser()
    return unparser.visit(ast_obj)
    
# _Unparser is defined in a seperate _ast_unparser.py file 

```

```
1. PraySourceLoader.exec_module(user_module)
   → apply_ast_transformations(tree, ...)
     → HeapAccessInstrumentationTransformer.visit(tree)
       → ast.unparse(recv)                          ← FIRST CALL to ast.unparse
         → try: _Unparser()  →  NameError           ← _Unparser not defined yet
         → except: from _ast_unparse import Unparser as _Unparser
           → Python starts importing _ast_unparse
             → sys.meta_path is searched
               → PrayMetapathFinder.find_spec("_ast_unparse", ...)
                 → _ast_unparse.py ends with .py, passes filter → INTERCEPT
                 → PraySourceLoader.exec_module(_ast_unparse)
                   → apply_ast_transformations(_ast_unparse tree, ...)
                     → ast.unparse(...)              ← SECOND CALL (re-entrant)
                       → try: _Unparser()  →  NameError
                       → except: from _ast_unparse import Unparser as _Unparser
                         → _ast_unparse is PARTIALLY INITIALIZED in sys.modules
                         → ImportError: cannot import name 'Unparser' from
                           partially initialized module '_ast_unparse'

```