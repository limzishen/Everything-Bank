---
tags: [ai-edited]
---
![[Pasted image 20260512175836.png|156]]
Basically generics

Code is generated per type at **compile time** (instantiation). No runtime cost, unlike Java generics, which erase types.
```cpp
template <typename T>
T max_of(T a, T b) { return a < b ? b : a; }       // function template

template <typename T, std::size_t N>
struct Buffer { T data[N]; };                       // class template, non-type param

// C++20 concepts: constrain T, get readable errors
template <std::totally_ordered T>
T clamp_to(T v, T lo, T hi);
```
- Definitions usually live in **headers**: the compiler needs the body at the point of instantiation ([[Header Files]]).
- Costs: code bloat (one copy per type), slower compiles, and (pre-concepts) awful error messages.
- `auto` parameters in lambdas / abbreviated templates (`void f(auto x)`) are templates too.

# Related
- [[Classes]] · [[Overloading function call operator]]
