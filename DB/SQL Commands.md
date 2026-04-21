# Selecting
``` 
SELECT column_name FROM table_name 
SELECT DISTINCT column_name FROM table_name 
SELECT COUNT(DISTINCT(coulmn)) FROM table 

# if only slecting select number
LIMIT n

```

# Filtering 
```
WHERE column = "Condition"
# can be any operator 

|=|Equal||
|>|Greater than||
|<|Less than||
|>=|Greater than or equal||
|<=|Less than or equal||
|<>|Not equal. **Note:** In some versions of SQL this operator may be written as !=||
|BETWEEN|Between a certain range||
|LIKE|Search for a pattern||
|IN|To specify multiple possible values for a column|
|NULL|
AND to join different conditions 
OR 
NOT


```

# Sorting 
``` 
SELECT * FROM table 
ORDER BY Column, ASC/DEC: 
```

# Insertion 
``` 
INSERT INTO Customers (CustomerName, City, Country)  
VALUES ('Cardinal', 'Stavanger', 'Norway');
```

# Update 
```
UPDATE _table_name_  
SET _column1_ = _value1_, _column2_ = _value2_, ...  
WHERE _condition_;
```

# Deletion 
``` 
# Delete row on condition 
DELETE FROM Customers WHERE CustomerName='Alfreds Futterkiste';

# Delete column 
DELETE FROM column
```

# Aggregate 
```
- `MIN()` - returns the smallest value within the selected column
- `MAX()` - returns the largest value within the selected column
- `COUNT()` - returns the number of rows in a set
- `SUM()` - returns the total sum of a numerical column
- `AVG()` - returns the average value of a numerical column
```

# Alias 
Assign a different name to the colume, useful for getting relational table to avoind long ass names 

```
    SELECT c.CustomerName AS Name, o.OrderDate AS PurchaseDate
    FROM Customers AS c
    JOIN Orders AS o ON c.CustomerID = o.CustomerID;
```

# Joining 

## join 
