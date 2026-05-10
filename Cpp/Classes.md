# Concrete classes 
## Container 
Issue with container classes is that there is no garbage collection so you will have to define the memory dealloc manually for the classes 

use ~ to dealloc memory 
```
class Vector {
public:
	Vector(int s) :elem{new double[s]}, sz{s} { 
		for (int i=0; i!=s; ++i) 
			elem[i]=0;
	}

	˜Vector() { delete[] elem; } // define the deconstructor 
	
	double& operator[](int i);
	int size() const;
	
private:
	double∗ elem; int sz;
};
```

### Move values 
```
Vector::Vector(std::initializer_list<double> lst) // initialize with a list
:elem{new double[lst.size()]}, sz{static_cast<int>(lst.size())}
{
	copy(lst.begin(),lst.end(),elem); // copy from lst into elem (§13.5)
}

// static cast is used because .size is a unsigned value 
```