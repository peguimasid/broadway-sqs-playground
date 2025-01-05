defmodule BroadwaySqsPlaygroundWeb.MessagesController do
  use BroadwaySqsPlaygroundWeb, :controller

  def create(conn, _params) do
    conn |> json(%{ok: true})
  end
end
