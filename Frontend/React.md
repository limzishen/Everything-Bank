## Props and State
Props are immutable 
State can be changed 
If props have to be changed, have to re-render 
## React lifecycle 
### Mounting 
When it loads, render the component and insert it into the DOM 

### Updating 
When props or state change, re-render 
### unmounting 
Remove component from the DOM 

## React Virtual DOM 
DOM (Document Object Model) the HTML rendering of react 
Virtual DOM is virtual representation of the UI as a tree of JavaScript Object 
State change updates the Virtual DOM tree 
Run a diffing algorithm with the virtual DOM and actual DOM 
Update the real DOM 

