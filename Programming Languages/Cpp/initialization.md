Initialise values on the stack 
``` 
// copy initialization
int a; 
a = 4;

// direct initialization 
int a(4); 

// list initialization (recommended way to initialize)
// Because there are no narowing coversion 
// Will just straight up throw error if things are not right 

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

# Constant 

``` 
Object that are immutable
const int num{0}; 
constexpr double s2 = sqrt(int) // the calculation will be done at compile 

constexpr will throw error if its depended on runtime variable 

vector<double> v {1, 2, 3, 4}; 
const v_sum = sum(v); // ok sun is calculated at run time
constexpr v_sum = sum(v); // compilation error since it will try and calculate at compilation 

```
![[Pasted image 20260506140326.png]]
Usage of constexpr to define a function allows it to be ran at compile time 

Constexpr are C++ pure functions, no side effects and only use arguments as input info 
Can be used at both compile time and runtime

# For loops 
## Iterating through array 
``` 
int v[] = {1, 2, 3, 4}; 
for (auto x: v) {
	++x; 
	// array v is not mutated 
	// x is a copy of the value of the array 
	std::cout<<x <<'\n'; 
}

// use & to reference to 
for (auto& x: v) {
	++x; 
	// x is mutated
}
```

# Pass by reference 
``` 
void sort(std::vector<double>& v); //sorts the vector through the reference 

void sort(const std::vector<double>&) // pass by reference but not mutate the value
```

## nullptr 
Similar to java null but used for pointers 


# Class constructor 

```
export module Vector; // defining the module called "Vector"
export class Vector {
	public:
		Vector(int s);
		double& operator[](int i);
		int size();
	private:
		double∗ elem; int sz; // elem points to an array of sz doubles
		
}

Vector::Vector(int s)
	:elem{new double[s]}, sz{s} {} // this directly initialise the elements 
// no need for body 

// initialize members
double& Vector::operator[](int i){
	 return elem[i];
}

int Vector::size() {
	return sz;
}

export bool operator==(const Vector& v1, const Vector& v2) {
	if (v1.size()!=v2.size()) {
		return false;
	}

	for (int i = 0; i<v1.size(); ++i) {
		if (v1[i]!=v2[i]){
			return false;
			return true;
		}
	}
}
```