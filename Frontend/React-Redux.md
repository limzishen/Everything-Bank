# Redux 
Library for state management 

# Benefits over pure react 
Performance optimization over pure react 
The component tree are not rerendered and the componenet only rerenders when it needs to
Centralized application state across many places
App state are updated frequenty 
Complicated state logic 
# Flow of redux state management 
![[Pasted image 20260623172732.png]]

1. Change of state 
2. Dispatcher creates an Action event 
3. Sends the action event into Store 
4. Store update itself with the new state 
5. UI is updated with the new state