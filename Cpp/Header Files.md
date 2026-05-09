Header files provides an interface of methods and sttibute of the class 
Let the code know when you are importing the class what to expect 

```
// Vector.h:
class Vector {
	public:
		Vector(int s);
		double& operator[](int i);
		int size();
	private:
		double∗ elem; int sz;
};

// user.cpp:
#include "Vector.h" #include <cmath> // get Vector’s interface
// get the standard-library math function interface including sqrt()

double sqrt_sum(const Vector& v) {
	double sum = 0;
	for (int i=0; i!=v.size(); ++i)
		sum+=std::sqrt(v[i]); 
	return sum;
}

// Vector.cpp:
#include "Vector.h" // get Vector’s interface
Vector::Vector(int s)
:elem{new double[s]}, sz{s} // initialize members
{
}

// Rest of the vecotrs implementation
// vector.cpp need to import the header file in ensure consistentcy in implementation

```

![[Pasted image 20260507205025.png]]

## Issues 
- increase compilation time (vector.h file is repeatedly compiled)
- Order of dependency matters 
- Inconsistencies between implementation will crash
- Transitivity:  all the code needed for th header file have to also be express 

# Module
## Advantage of module over header files 

- Reduce fragility 
	- if multiple header files use the same constant but defined differently things wont crash 
- More efficient 
	- Less repeated compiling of the header files 


# Namespace 
Can span multiple files 
Basically a library 


