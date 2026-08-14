in C++, allows overloading of standard operatore 
``` 
Complex operator+(const Complex& other) {
    return Complex(real + other.real, imag + other.imag);
}
```
given a class you can change what the operator does for the class
now if you use the operator on the class it does something else
