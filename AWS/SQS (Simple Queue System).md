---
tags: [ai-edited]
---
SQS is a queue. Producers place messages in the queue, and messages sit there for up to 14 days (default retention 4 days).

The consume cycle: 
- Consumer calls `ReceiveMessage`, gets a message
- Message becomes _invisible_ to other consumers for the **visibility timeout** (default 30s)
- Consumer does its work, then calls `DeleteMessage`
- If it never deletes — crash, timeout, unhandled exception — the message becomes visible again and gets redelivered

# Standard vs FIFO
- **Standard**: at-least-once delivery, best-effort ordering, nearly unlimited throughput, so consumers must be **idempotent**.
- **FIFO**: exactly-once processing within a message group, strict order, lower throughput.

# Dead-letter queue (DLQ)
After `maxReceiveCount` failed receives, the message moves to a DLQ for inspection instead of looping forever.

Often paired with [[SNS (Simple Notification System)|SNS]] for fan-out. Conceptually it's the [[Producer Consumer Problem]] as a managed service.
