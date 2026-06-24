Builds on top o [[ExpressJs]]

# Key Characteristic 
- Modular architecture 
- Dependency injection 
- Opinionated 
- Less boilerplate 

# Module 
Declares what controllers and providers belong together, and what it imports from / exports to other modules.
# Controller 
The http layer . It receives the request, calls a service, returns the result.

```JavaScript 
@Controller('users')          // route prefix: /users
export class UsersController {
  constructor(private usersService: UsersService) {}  // injected

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);   // delegate to service
  }
}

// similar to expressJS 
app.get('/users/:id', ...)
```


# Dependency injection 
```javaScript 
class UsersService {
  constructor(private db: Database) {}   // ← receives it, doesn't build it

  findOne(id: string) { return this.db.query(...); }
}
```
The class _declares_ what it needs but doesn't build it. Something else builds it and passes it in through the constructor
