# Props
Props are immutable data passed from parent component to child
If props have to be changed, have to re-render 
# State
State can be changed 
When there are state changes, the components are re-rendered through the Virtual DOM
```Javascript
import { useState } from 'react';

export default function Form() {
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [fullName, setFullName] = useState('');

// Any mutation of the state will lead to the UI change
  function handleFirstNameChange(e) {
    setFirstName(e.target.value);
    setFullName(e.target.value + ' ' + lastName);
  }
  
```

look at [[React Hooks]] to see how to store and mutate state
# Reducer 
A pure function that takes in a input and produce an output with no side effects.
Reduce messy and unnecessary event handler if the functions are simple enough 
# React lifecycle 
## Mounting 
When it loads, render the component and insert it into the DOM
## Updating 
When props or state change, re-render 
## Unmounting 
Remove component from the DOM 

# React Virtual DOM 
DOM (Document Object Model) the HTML rendering of react 
Virtual DOM is virtual representation of the UI as a tree of JavaScript Object 
State change updates the Virtual DOM tree 
Run a diffing algorithm with the virtual DOM and actual DOM 
Update the real DOM 

