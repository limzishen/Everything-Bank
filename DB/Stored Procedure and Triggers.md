

# Stored Procedures and Functions

Functions in PL/pgSQL allow you to encapsulate logic, accept parameters, and return various data types.

**Basic Syntax:**

```
CREATE OR REPLACE FUNCTION <function_name> (
    IN <param_name> <type>, 
    OUT <param_name> <type>, 
    INOUT <param_name> <type>
)
RETURNS SETOF <table_name> | RECORD AS $$
BEGIN
    -- Function logic goes here
END; 
$$ LANGUAGE plpgsql;
```

**Key Notes on Functions:**

- **Roles:** Functions can have multiple roles using `IN`, `OUT`, and `INOUT` parameters.
- **Return Types:** You must explicitly specify the return type.
- **Table Returns:** If returning a `SETOF <table_name>`, the returned records must exactly match the columns of that specific table.
- **Procedures without returns:** If you are building a stored procedure that doesn't need to return data, you can omit the `RETURNS` clause.
- **Variable Assignment:** Use the `INTO` keyword to load the result of a query into a variable (e.g., `SELECT column INTO variable`).

# Cursors
Cursors allow you to iterate through a result set row by row, which is useful for complex calculations that cannot be done in a single set-based operation.

**Cursor Implementation Steps:**

```
-- Assuming standard function declaration and RETURNS setup above

DECLARE
    -- Declare the cursor and the query it will iterate on
    cur CURSOR (<variable_type>) FOR 
        <SELECT statement what you want to iterate on>;
    
    -- <other variables> can be declared here

BEGIN
    -- 1. Open the cursor
    OPEN cur(<variable>);
    
    -- 2. Start the loop
    LOOP
        -- 3. Fetch the current row into a record variable
        FETCH cur INTO curr;
        
        -- 4. Exit condition
        EXIT WHEN NOT FOUND;
        
        -- <Calculations and logic using 'curr'>
        
    END LOOP;
    
    -- 5. Close the cursor
    CLOSE cur;
    
    RETURN <result>;
END;
```

## 3. Triggers

Triggers are special functions that automatically execute in response to database events (like `INSERT`, `UPDATE`, or `DELETE`). Creating a trigger involves two steps: writing the trigger function and defining the trigger itself.

**Step A: The Trigger Function**

```
CREATE OR REPLACE FUNCTION <function_name>()
RETURNS TRIGGER AS $$
BEGIN
    -- Trigger logic (See behavior rules below)
END;
$$ LANGUAGE plpgsql;
```

**Step B: The Trigger Definition**

```
CREATE CONSTRAINT TRIGGER <trigger_name>
<BEFORE | AFTER> INSERT OR UPDATE OR DELETE ON <table_name>
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW -- (Optional for row-level trigger)
EXECUTE PROCEDURE <function_name>();
```

### Trigger Behavior and Validation Checks

Handling successes and failures depends heavily on whether the trigger fires `BEFORE` or `AFTER` the event.

- **Handling Success:** `RETURN NEW;` allows the operation to proceed successfully.
    
- **Handling Failure (Failing Trigger Check):**
    
    - `RETURN NULL;`: No error message is thrown, but the operation is skipped/aborted for that specific row.
        
    - `RAISE EXCEPTION`: Stops the entire transaction and the transaction is rolled back.
        

**`BEFORE` vs `AFTER` Constraints:**

- **BEFORE Check:** You **can** use `RETURN NULL;` to skip rows. For `UPDATE` and `INSERT` triggers, you can actively modify the `NEW` row values before they hit the table.
    
- **AFTER Check:** You **cannot** use `RETURN NULL;` (it will be ignored). If a check fails here, you **have to** use `RAISE EXCEPTION` to roll back the transaction.
    

### The `OLD` and `NEW` Records

Inside a trigger function, you have access to the state of the row before (`OLD`) and after (`NEW`) the triggering event.

- **`OLD`**: Gives you the row value _before_ changes occur. For a `DELETE` trigger, returning `OLD` allows the deletion to proceed.
    

|Timing|`OLD` Record|`NEW` Record|
|---|---|---|
|**BEFORE**|Read-only|Read and Write|
|**AFTER**|Read-only|Read-only|

### `INSTEAD OF` Triggers

- **When to use:** These are primarily used when working with **Views** or CTEs (Common Table Expressions).
    
- **Why:** You have to use `INSTEAD OF` triggers on views because standard views are generally read-only. The trigger intercepts the insert/update/delete command and runs your custom logic _instead of_ trying to directly modify the underlying view.