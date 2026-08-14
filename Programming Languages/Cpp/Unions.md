A union is a struct in which all members have the same address
Only takes up as much space as the largest member
Its basically if you need to only fill in one variable instead of using null for multiple datatype use union 


``` 
// you can initialise the value of the union with either Node or int 
union Value {
	Node∗ p;
	int i;
};

// safer way to do it is with variant, no need to create a new object ig 
struct Entry {
	string name;
	variant<Node∗,int> v;
};
```