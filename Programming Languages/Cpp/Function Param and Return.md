```
void func(double val1, double& val2) {
	val1 = 99; // local variable value is copie 
	val2 = 100 // variable is passed by reference value is changed 
}
```

# Value return 
``` 
class Vector {
	public:
	private:
	double∗ elem; 
	double& operator[](int i) { return elem[i]; } 
	// return reference to ith element
};
```

Be careful when returning by reference 
Do not return a reference to a local variable 
```
int& bad() {
	int x;
	//...
	return x; // bad: return a reference to the local variable x
}
```

## return value optimisation 
Copy elison 
The compiler will choose between copying or reassigning the memory
```
Matrix operator+(const Matrix& x, const Matrix& y)
{
	Matrix res;
	// ... for all res[i,j], res[i,j] = x[i,j]+y[i,j] ...
	return res;
}

// Try not to resort to memory management like this by returning the memory pointer

Matrix∗ add(const Matrix& x, const Matrix& y) // complicated and error-prone 20th century style
{
	Matrix∗ p = new Matrix;
	// ... for all *p[i,j], *p[i,j] = x[i,j]+y[i,j] ...
	return p;
}

```

# Structured Bindings
no need to create a new struct 
Will auto bind to the return type defined 

```
struct Entry {
	string name;
	int value;
};


Entry read_entry(istream& is) {
	string s;
	int i;
	is >> s >> i;
	return {s,i};
}
```
