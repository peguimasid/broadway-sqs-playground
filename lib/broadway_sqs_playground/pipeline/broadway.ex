defmodule BroadwaySqsPlayground.Pipeline.Broadway do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          BroadwaySQS.Producer,
          queue_url: "http://localhost:4566/000000000000/sqs-demo",
          config: [
            scheme: "http://",
            host: "localhost",
            port: 4566,
            access_key_id: "",
            secret_access_key: ""
          ]
        }
      ],
      processors: [
        default: []
      ],
      batchers: [
        default: []
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{data: data} = message, _) do
    IO.inspect(data, label: "******* Message ********** ")

    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages
  end
end
