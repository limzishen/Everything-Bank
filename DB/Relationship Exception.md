## Exception 1 
When creating a relation table 
![[Pasted image 20260227165616.png]]
```
WRONG
CREATE TABLE work_for (
	start_date DATE NOT NULL,
	emp_number CHAR(8),
	name VARCHAR(32),
	PRIMARY KEY (emp_number, name), -- violates (0, 1) because can have more than one company for each employee
	FOREIGN KEY (emp_number)
	REFERENCES employees(emp_number),
	FOREIGN KEY (name)
	REFERENCES companies(name)
);

CORRECT 
CREATE TABLE work_for (
	start_date DATE NOT NULL,
	emp_number CHAR(8),
	name VARCHAR(32) NOT NULL,
	PRIMARY KEY (emp_number),
	FOREIGN KEY (emp_number)
	REFERENCES employees(emp_number),
	FOREIGN KEY (name)
	REFERENCES companies(name)
);

Enforce 0,1 with using the entity primary key 
```

## Exception 2 

![[Pasted image 20260227170053.png]]

The incorrect one doesnt enforce the minimum  1 rule as you can insert in Employee but not in work for table 

![[Pasted image 20260227165915.png]]
This combines the employee table and the work for relationship table into one 
Ensures every employee work for (1, 1)

## Exception 3 
![[Pasted image 20260301115026.png]]
![[Pasted image 20260301115108.png]]
