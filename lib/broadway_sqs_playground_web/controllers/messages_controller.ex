defmodule BroadwaySqsPlaygroundWeb.MessagesController do
  use BroadwaySqsPlaygroundWeb, :controller

  def send_message(conn, _params) do
    config = [
      scheme: "http://",
      host: "localhost",
      port: 4566,
      access_key_id: "",
      secret_access_key: ""
    ]

    queue_url = "http://localhost:4566/000000000000/sqs-demo"

    messages =
      1..100
      |> Enum.map(fn _ ->
        message_body = JSON.encode!(%{"id" => UUID.uuid4(), "message" => "Hello"})

        response =
          queue_url
          |> ExAws.SQS.send_message(message_body)
          |> ExAws.request!(config)

        response
      end)

    conn
    |> json(%{
      message: "#{length(messages)} messages successfully send to queue"
    })
  end
end
