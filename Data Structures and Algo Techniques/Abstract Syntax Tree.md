---
tags: [ai-edited]
---
A tree data structure that represents the syntax of the source code 

# AST vs parse tree
- **Parse (concrete syntax) tree**: mirrors the grammar exactly, including punctuation, parentheses, and every intermediate rule.
- **AST**: keeps only semantically meaningful structure. `(a + b) * c` becomes `Mul(Add(a, b), c)`, and the parentheses are encoded by the tree shape.

# Pipeline position
`source → tokens → parser → AST → semantic analysis (symbol table) → IR / bytecode`
See [[Python Execution Model]] for CPython's version.

# Working with Python ASTs
```python
import ast
tree = ast.parse("x[0] += 1")
print(ast.dump(tree, indent=2))   # AugAssign(target=Subscript(...), op=Add(), value=Constant(1))

class Rewriter(ast.NodeTransformer):
    def visit_AugAssign(self, node):
        self.generic_visit(node)
        return node                 # return new node(s) to rewrite
tree = ast.fix_missing_locations(Rewriter().visit(tree))
exec(compile(tree, "<ast>", "exec"))
```
- `NodeVisitor` reads the tree, `NodeTransformer` rewrites it, `ast.unparse` turns it back into source.
- This is exactly how Pray instruments code at import time: see [[heap access]] and [[Pray AST]].

# Other uses
Linters (ruff, pylint), formatters (black), code search ([[Project Idea|tree-sitter indexing idea]]), macros, and transpilers.
