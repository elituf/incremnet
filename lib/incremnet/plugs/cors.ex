defmodule Incremnet.Plugs.Cors do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn =
      conn
      |> put_resp_header("Access-Control-Allow-Origin", "*")
      |> put_resp_header("Access-Control-Allow-Methods", "*")
      |> put_resp_header("Access-Control-Allow-Headers", "*")
      |> put_resp_header("Access-Control-Max-Age", "3600")

    if conn.method == "OPTIONS" do
      conn
      |> send_resp(204, "")
      |> halt()
    else
      conn
    end
  end
end
