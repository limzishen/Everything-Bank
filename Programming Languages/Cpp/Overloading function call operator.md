---
tags: [ai-edited]
---
in C++, allows overloading of standard operatore 
``` 
Complex operator+(const Complex& other) {
    return Complex(real + other.real, imag + other.imag);
}
```
given a class you can change what the operator does for the class
now if you use the operator on the class it does something else

# The function call operator `operator()`
Overloading `()` makes an object callable: a **functor**. Unlike a plain function, it can hold state, and the compiler can inline it (it's often faster than a function pointer when passed to STL algorithms).
```cpp
struct Greater {
    int threshold;
    bool operator()(int x) const { return x > threshold; }
};
std::vector<int> v{1, 5, 9};
auto n = std::count_if(v.begin(), v.end(), Greater{4});   // 2

// lambdas are syntactic sugar for an unnamed functor class
auto gt4 = [t = 4](int x) { return x > t; };
```
Also used for custom comparators/hashers: `std::priority_queue<T, vector<T>, Cmp>`, `std::unordered_map<K, V, Hash>`.

# Related
- [[Key Operations]] · [[Classes]] · [[Template]]
