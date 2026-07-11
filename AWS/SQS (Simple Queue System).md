SQS is a queue. [[SNS (Simple Notification System) | Producers]] place message in the queue. Message sit in the queue up to 14 dyas 

The consume cycle: 
- Consumer calls `ReceiveMessage`, gets a message
- Message becomes _invisible_ to other consumers for the **visibility timeout** (default 30s)
- Consumer does its work, then calls `DeleteMessage`
- If it never deletes — crash, timeout, unhandled exception — the message becomes visible again and gets redelivered


