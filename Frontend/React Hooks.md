# State hooks 
Basically like a variable where by changing it will lead to re rendering 
useState 
useReducer 

```JavaScript 
function ImageGallery() {  
const [index, setIndex] = useState(0);
// ..
```

# Context Hooks 
Context allows for component to receive information from distant parents without passing it as props 
```JavaScript
function Button() {
  const theme = useContext(ThemeContext);
  // ...
```

# Ref Hooks 
Allow components to use information that are not used for rendering 
Basically a variable that allows component to hold information 
typically used to hold a DOM node 


# Effects Hooks 
typically used to monitor a state and capture side effects 
Try not use for the rendering workflow if you are going to render the component with useEffect
Leads to cascading state change 

``` JavaScript 
function ChatRoom({ roomId }) {
  useEffect(() => {
    const connection = createConnection(roomId);
    connection.connect();
    return () => connection.disconnect();
  }, [roomId]);
  // ...
```

# Performance Hooks 
Hooks that optimize performance 
useMemo  - cache the expensive function calls results 
useCallback = cache the function definition before passing it down 
