# Pessimistic locking 
Basically similar to locks in concurrency 
``` 
BEGIN TRANSACTION; 
... YOUR ACTION

COMMIT; 

```

Basically everything between start and end will be locked until transactions end 

# Optimistic locks 

```
UPDATE wallets
SET 
    balance = balance - 60,
    version = version + 1       -- increment version
WHERE 
    user_id = 1
    AND version = 0;            -- the critical check
```

Basically have an id version. Check if the version is valid before updating 
If there are Write from a different thread after read the version ID will be different 

only discard a write when there are mutex violation is detected 

