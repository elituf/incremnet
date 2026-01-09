defmodule Incremnet.Plugs.Cors do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if Mix.env() == :dev do
      conn =
        conn
        |> put_resp_header("Access-Control-Allow-Origin", "*")
        |> put_resp_header("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE, OPTIONS")
        |> put_resp_header("Access-Control-Allow-Headers", "Authorization, Content-Type")

      if conn.method == "OPTIONS" do
        conn
        |> send_resp(200, "")
        |> halt()
      else
        conn
      end
    else
      conn
    end
  end
end
