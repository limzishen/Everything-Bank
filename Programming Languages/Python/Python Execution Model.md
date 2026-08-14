# Tokenising 
The source text are tokenise to simplify the grammatical rules before parsing into AST. 
Since python use indentation and new line as part of its grammar, the tokenisation is important to ensure that the syntactical structure is context free. 
# Parsing 
The token stream generate by the tokenizer will be fed into the parser which builds the Abstract Syntax Tree

Parsing into AST tree provides additional context to the to the tokens
Example: 
``` Python 
if x == 0: 
	return none
```

Tokenises into

```
ENCODING    (0,0)   (0,0)    'utf-8'
NAME        (1,0)   (1,2)    'if'
NAME        (1,3)   (1,4)    'x'
OP          (1,5)   (1,7)    '=='
NUMBER      (1,8)   (1,9)    '0'
OP          (1,9)   (1,10)   ':'
NEWLINE     (1,10)  (1,11)   '\n'
INDENT      (2,0)    (2,4)   ' '
NAME        (2,0)   (2,6)    'return'
NAME        (2,7)   (2,11)   'none'
NEWLINE     (2,11)  (2,12)   '\n'
ENDMARKER   (3,0)   (3,0)    ''
```

Parse into AST
```
Module(
  body=[
    If(
      test=Compare(
        left=Name(id='x', ctx=Load()),
        ops=[Eq()],
        comparators=[Constant(value=0)]),
      body=[
        Return(value=Name(id='none', ctx=Load()))],
      orelse=[])],
  type_ignores=[])
```

Provides context to the operators and the NAME value

# Symtable Analysis
  
1. **Walks the AST** — traverses every node, building a tree of `_symtable_entry` objects, one per scope (module, function, class, type alias, etc.).

2. **Tracks definitions and uses** — for each name it encounters, it records whether it's a definition (`DEF_LOCAL`, `DEF_PARAM`, `DEF_IMPORT`, `DEF_GLOBAL`, `DEF_NONLOCAL`, etc.) or a use (`USE`).

3. **Propagates visibility** — child scopes need access to enclosing scopes' variables. The symtable propagates this information so the compiler knows which variables need cell objects (for closures) or `LOAD_GLOBAL`/`LOAD_NAME` instructions.

4. **Validates semantics** — emits syntax warnings/errors for things like:
	   - `global x` after `x` was already assigned locally
	   - `nonlocal x` where `x` doesn't exist in an enclosing scope
	   - `import *` inside a function
	   - Walrus operator (`:=`) misuse in comprehensions
	   - Async constructs outside async functions
	   - Duplicate type parameters
	
5. [[Name Mangling]] — for class-private names (prefixed with `__`), the symtable performs name mangling (e.g., `__foo` in class `Bar` becomes `_Bar__foo`) 

# AST optimiser
## Fold
it goes through the AST and calculate every every binary expression instead of deferring the calculation to runtime.  (e.g fixed variable calculation like 2 + 2/tuple are computed fold optimization)

# Bytecode Gen
For each AST node, it recursively vist the nodes and generate stack instructions [[instruction Set Architecture (ISA)]]. 
The instructions are broken down into code blocks in a graph form to represent control flows
Pseudo instructions are left in and unoptimised
Jump instruction points to code block instead of numbers
Since its control flow are represented as graphs
This is not the final bytecode generation. 

## Optimisation 
Optimization like dead block elimination, jump threading (if there are chained jump instructions)
## Assembly
Rewrite from block address jump instruction to offset jump for if else instruction
Linearise the bytecode instructions

# Evaluation 
The python/ceval.c is a stack machine. 
The code object (Bytecode + constant/name/size table) is executed within a frame. 

## Python Frame 
Contains: 
- Local variables 
- instruction pointer 
- Operand stack





