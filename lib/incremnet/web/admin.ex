defmodule Incremnet.Web.Admin do
  use Plug.Router

  plug(:match)
  plug(Incremnet.Plugs.LogConn)
  plug(Incremnet.Plugs.RateLimit)
  plug(Incremnet.Plugs.RequireBearer)
  plug(:dispatch)

  put "/:key/:count" do
    with {count, ""} <- Integer.parse(count) do
      count_previous = Incremnet.Server.get(key)
      Incremnet.Server.set(key, count)
      send_json(conn, 200, %{key: key, count_previous: count_previous, count: count})
    else
      _ -> send_resp(conn, 400, "count must be an integer")
    end
  end

  delete "/:key" do
    count_previous = Incremnet.Server.get(key)
    Incremnet.Server.delete(key)
    send_json(conn, 200, %{key: key, count_previous: count_previous})
  end

  match _ do
    send_resp(conn, 404, "no such route: #{conn.method} #{conn.request_path}")
  end

  defp send_json(conn, status, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, JSON.encode!(body))
  end
end
