Initialise values on the stack 
``` 
// copy initialization
int a; 
a = 4;

// direct initialization 
int a(4); 

// list initialization (reccomended way to initialize)
int a{1}; 
```

## Optional variable 
```
#include <iostream>

int main()
{
    [[maybe_unused]] double pi { 3.14159 };  // Don't complain if pi is unused
    [[maybe_unused]] double gravity { 9.8 }; // Don't complain if gravity is unused
    [[maybe_unused]] double phi { 1.61803 }; // Don't complain if phi is unused

    std::cout << pi << '\n';
    std::cout << phi << '\n';

    // The compiler will no longer warn about gravity not being used

    return 0;
}
```

The compiler wont complain about the unused variable 
