Built on [[NodeJS]]

# Key Characteristics 
- Minimal and flexible
- Unopinionated (you decide how to structure your app)
- Lightweight and fast
- Extensible through middleware
- Huge ecosystem of plugins and extensions

# Routing 
- `app.get()` - Handle GET requests
- `app.post()` - Handle POST requests
- `app.put()` - Handle PUT requests
- `app.delete()` - Handle DELETE requests
- `app.all()` - Handle all HTTP methods

## Route params
Route parameters are named URL segments that are used to capture the values specified at their position in the URL

The parameters are the values in the position of the request URL
```JavaScript 
const express = require('express');  
const app = express();  
const port = 8080;  
  
// Route with parameters  
app.get('/users/:userId/books/:bookId', (req, res) => {  
  // Access parameters using req.params  
  res.send(`User ID: ${req.params.userId}, Book ID: ${req.params.bookId}`);  
});  

// .send() returns the value to the frontend
  
app.listen(port, () => {  
  console.log(`Example app listening at http://localhost:${port}`);  
});
```

## Query Params 
Query params are the key-value pairs that come after the ? 
They're for filtering, sorting, pagination, search
Modifies how you would want a resource 

```
/products?category=shoes&sort=price&page=2
          └──────────────┬──────────────┘
                    query string
```

# Middleware 
## Mutate res/req 
```javascript
app.use((req, res, next) => {
  // 1. inspect/modify req or res
  req.requestTime = Date.now();

  // 2. EITHER call next() to continue...
  next();

  // 3. ...OR send a response to end the chain (don't do both)
  // res.status(403).send('blocked');
});
```

## Pass it on 
Express keeps a list of middleware that are ordered 
```JavaScript 
app.use(logger);        // runs on everything
app.use(express.json()); // parses JSON body for everything
app.use(authenticate);   // gates everything below it

app.get('/users', (req, res) => {
  // by the time we're here, body is parsed, user is logged, auth passed
  res.json(users);
});
```
Each request will go through the list of middleware functions 
It allow for different request to pass through a similar workflow 

``` JavaScript
function logger(req, res, next) {
  const start = Date.now();

  // res.on('finish') fires once the response has been sent
  res.on('finish', () => {
    const ms = Date.now() - start;
    console.log(`${req.method} ${req.url} → ${res.statusCode} (${ms}ms)`);
  });

  next();
}
```

