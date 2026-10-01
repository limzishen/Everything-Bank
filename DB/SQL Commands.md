---
tags: [ai-edited]
---
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
ORDER BY Column ASC|DESC
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

# Delete column (DDL, not DELETE)
ALTER TABLE Customers DROP COLUMN City;
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

# Grouping
```
SELECT country, COUNT(*) AS n
FROM Customers
WHERE active                -- filters rows BEFORE grouping
GROUP BY country
HAVING COUNT(*) > 5         -- filters groups AFTER aggregation
ORDER BY n DESC;
```
Logical order: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

# Joining
```
SELECT * FROM A INNER JOIN B ON A.id = B.a_id   -- only matching rows
SELECT * FROM A LEFT  JOIN B ON A.id = B.a_id   -- all of A, NULLs where B missing
SELECT * FROM A RIGHT JOIN B ON ...             -- all of B
SELECT * FROM A FULL OUTER JOIN B ON ...        -- all rows from both
SELECT * FROM A CROSS JOIN B                    -- cartesian product
```
- Anti-join ("in A but not B"): `LEFT JOIN B ... WHERE B.a_id IS NULL` or `NOT EXISTS`.
- Self-join: join a table to itself with aliases (e.g. employee ↔ manager).

# Related
- [[SQL]] · [[DDL]] · [[Optimise Query]] · [[Pandas]]
