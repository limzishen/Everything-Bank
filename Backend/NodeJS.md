Single threaded, event-driven and non IO blocking model 

# Core Architecture 
Single threaded runtime management 
Task are sent to the event queue 
Task are separated into IO blocking and Non IO blocking event 

Non IO blocking task are executed immediately 
IO blocking task are sent to the event loop
![[Pasted image 20260624105624.png]]
The phases are processed in this looping order 
Each of the phases have a FIFO queue 
