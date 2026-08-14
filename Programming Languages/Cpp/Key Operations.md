# Constructors 
```
class X {
public:
	X(Sometype); //‘‘ordinary constructor’’: create an object
	X(); // default constructor
	X(const X&); // copy constructor
	X(X&&); // move constructor
	X& operator=(const X&); // copy assignment: clean up target and copy
	X& operator=(X&&); // move assignment: clean up target and move
	˜X(); // destructor: clean up
	//...
};

// copy and move constructor can be optimised 
X make(Sometype);
X x = make(value);

// directly construct from x 
// avoid eliding

// use default to show operator function is the same
// use delete to remove operations 
```

# Cool C++ operators
```
class R {
	//...
	auto operator<=>(const R& a) const = default;
};
void user(R r1, R r2)
{
	bool b1 = (r1<=>r2) == 0; // r1==r2
	bool b2 = (r1<=>r2) < 0; // r1<r2
	bool b3 = (r1<=>r2) > 0; // r1>r2
	bool b4 = (r1==r2);
	bool b5 = (r1<r2);
}

// (r1<=>r2) allow for 3 way comparison between 2 values 


```