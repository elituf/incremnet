defmodule Incremnet.Web.Router do
  use Plug.Router

  plug(Incremnet.Plugs.Cors)
  plug(:match)
  plug(:dispatch)

  forward("/badge", to: Incremnet.Web.Badge)
  forward("/admin", to: Incremnet.Web.Admin)

  match _ do
    send_resp(conn, 404, "no such route: #{conn.method} #{conn.request_path}")
  end

  def child_spec(_arg) do
    Plug.Cowboy.child_spec(
      scheme: :http,
      plug: __MODULE__,
      options: [port: Application.fetch_env!(:incremnet, :http_port)]
    )
  end
end
