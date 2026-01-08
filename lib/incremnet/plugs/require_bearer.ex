defmodule Incremnet.Plugs.RequireBearer do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    expected = Application.fetch_env!(:incremnet, :admin_token)
    authorization = get_req_header(conn, "authorization")

    case authorization do
      ["Bearer " <> token] ->
        if Plug.Crypto.secure_compare(token, expected) do
          conn
        else
          unauthorized(conn)
        end

      _ ->
        unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "unauthorized")
    |> halt()
  end
end
