# Concrete classes 
## Container 
Issue with container classes is that there is no garbage collection so you will have to define the memory dealloc manually for the classes 

use ~ to define dealloc memory 
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

# Abstract class 
```
// Parent container abstract class 

class Container {
public: 
	virtual double& operator[](int) = 0; // pure virtual function child class must implement this 
	virtual int size const = 0; 
	virtual ~Container(){} 	
}

class Vector_Container: public Container {
public: 
	Vector_Container(int s): v(s){}; 
	~Vector_Container() {}
	double& operator[](int i) override {return v[i];}
	int siz****e() const override { return v.size(); }
	// Override is optional but helps with compiler 

private: 
	Vector v; 
}

```

# Unique ptr or shared_ptr for resource management 
use standard library to avoid assigning the result of new to a naked pointer 
Unique_ptr will auto delete the object when its out of scope 

```
class Smiley : public Circle {
private:
	vector<unique_ptr<Shape>> eyes; // usually two eyes
	unique_ptr<Shape> mouth;
};
```