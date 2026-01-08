defmodule Incremnet.Web.Admin do
  use Plug.Router

  plug(:match)
  plug(Incremnet.Plugs.LogConn)
  plug(Incremnet.Plugs.RequireBearer)
  plug(:dispatch)

  get "/secret_endpoint" do
    send_resp(conn, 200, "banana")
  end

  post "/import" do
    send_resp(conn, 200, "")
  end

  get "/export" do
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "no such route: #{conn.method} #{conn.request_path}")
  end
end
