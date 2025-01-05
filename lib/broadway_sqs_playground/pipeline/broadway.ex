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
        default: [concurrency: 5]
      ],
      batchers: [
        default: []
      ]
    )
  end

  def prepare_messages(messages, _context) do
    messages =
      Enum.map(messages, fn message ->
        Message.update_data(message, fn data ->
          JSON.decode(data)
        end)
      end)

    messages
  end

  def handle_message(_, %Message{data: {:ok, data}} = message, _) do
    IO.inspect(data, label: "******* Message **********")

    message
  end

  def handle_message(_, %Message{data: {:error, err}} = message, _) do
    IO.puts("#{inspect(self())} Handling parsing error: #{inspect(err)}")
    Message.failed(message, :invalid_data)
  end

  def handle_failed(messages, _context) do
    IO.puts("Messages in failed stage: #{inspect(messages)}")

    Enum.map(messages, fn
      %{status: {:failed, :invalid_data}} = message ->
        IO.puts("ACK invalid message and log error: #{inspect(message.data)}")
        Message.configure_ack(message, on_failure: :ack)
        message
    end)
  end

  def handle_batch(_, messages, _, _) do
    messages
  end
end
