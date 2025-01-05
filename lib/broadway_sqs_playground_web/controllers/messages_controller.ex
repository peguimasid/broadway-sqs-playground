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
    message = JSON.encode!(%{"id" => UUID.uuid4(), "message" => "Hello"})

    response =
      queue_url
      |> ExAws.SQS.send_message(message)
      |> ExAws.request!(config)

    conn
    |> json(%{
      success: true,
      message_id: response[:body][:message_id]
    })
  end
end
