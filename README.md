# ZedRunner

## TXN States

```
pending
registered
confirmed
```


@WIP Goal is to build service that accomplishes these tasks

• Surfaces endpoint to receive payload of transaction ids
• Surfaces endpoint that returns json payload of Pending transactions

• Subscribes to updates from BlockNative api for status of specific txn ids

• When state is transaction state is `registered` or `confirmed` payload is sent to webhook (Slack)

• When transaction state is 





```mermaid

sequenceDiagram

participant client as Zed.Run.Client
participant zed as Zed-Elixir
participant block as BlockNative
participant slack as Slack Webhook

note over client,zed: Subscribe to Transaction.
client->>+zed: Specify one or more txns
zed->>+block: Subscribes to Transactions
block->>-zed: feeds data back

zed->>slack: pushes transaction status - when registered/confirmed data to Webhook

```