---
tags: [hub]
---
Hub for **pray-ast**, a cooperative-scheduling concurrency bug finder for Python. It rewrites code at import time ([[Abstract Syntax Tree]]), plants yield points around shared accesses, and lets a scheduling policy (`rand` / `pos` / `pct` / `urw` / `surw`) drive threads and processes into buggy interleavings.

# How it works
- [[heap access]]: the AST transformer that wraps shared heap reads/writes with scheduler hooks and yield points
- [[PCT (probabilistic concurrency testing)]]: the main scheduling policy and its probabilistic guarantee
- [[pray-ast fails on native blockingIO]]: where the cooperative model breaks (C-level blocking calls never yield)

# Multiprocessing support
- [[Pray Notes]]: why simulating processes with threads breaks memory semantics, the design options (shared-memory scheduler vs coordinator process), Python IPC primer
- [[Multiprocessing granularity]]: where to place cross-process checkpoints (trade-off of IPC cost vs interleaving coverage)
- [[Pray AST Multiprocessing]]: what was actually implemented (PR summary)
- [[test plans]]: integration test plan for the MP runtime

# Diary (chronological)
1. [[Pray AST thoughts - Jun 25]]: loguru testing, NativeIO list, todos
2. [[Pray meeting 24 Jul]]: multiprocessing / asyncio / socket todos
3. [[Pray Research Diary - 2 Aug 2026]]: fork start-method issues, scheduler generalisation
4. [[Pray Research Diary - 19 Aug 2026]]: URW/SURW fallback to rand in MP, PCT change points

# Background concepts
- Python runtime: [[Python Execution Model]] · [[Python Memory Model]] · [[GIL]] · [[AsyncIO]] · [[Threading - events]] · [[Python Multiprocessing vs Multithreading]]
- OS: [[Fork]] · [[Process]] · [[Thread]] · [[Context Switch]]
- Concurrency: [[Locks]] · [[Coffman Conditions]] · [[Producer Consumer Problem]] · [[Testing]]

Back to [[Home]]
