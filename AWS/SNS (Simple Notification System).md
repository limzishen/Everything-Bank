---
tags: [ai-edited]
---
SNS is a pub/sub service. A publisher writes one message to a **topic**, and SNS **pushes** a copy of the message to every subscriber.

> [!note] Naming
> The official name is Simple Notification **Service**.

# Subscribers
SQS queues, Lambda, HTTP/S endpoints, email, SMS, mobile push.

# SNS vs [[SQS (Simple Queue System)|SQS]]
| | SNS | SQS |
| --- | --- | --- |
| Model | pub/sub, push | queue, consumers **pull** |
| Delivery | fan-out to N subscribers | each message processed by one consumer |
| Persistence | none: if a subscriber is down, it relies on retries / DLQ | stored up to 14 days |

# Fan-out pattern (SNS → multiple SQS)
One event (e.g. `OrderPlaced`) is published to an SNS topic, and each downstream service owns its own SQS queue subscribed to that topic. You get decoupling, independent retry, and buffering per consumer. **FIFO topics + FIFO queues** preserve order.

Back to [[AWS]]
