defmodule BroadwaySqsPlaygroundWeb.MessagesController do
  use BroadwaySqsPlaygroundWeb, :controller

  def send_message(conn, _params) do
    conn |> json(%{ok: true})
  end
end
