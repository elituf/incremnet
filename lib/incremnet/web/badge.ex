defmodule Incremnet.Web.Badge do
  use Plug.Router

  plug(:match)
  plug(:fetch_query_params)
  plug(:dispatch)

  get "/" do
    case conn.params do
      %{"key" => key} ->
        value = Incremnet.Server.get(key)
        image = Incremnet.Assets.badge_background()

        body = Incremnet.Templates.badge(key, value, image)

        conn
        |> put_resp_content_type("text/html")
        |> send_resp(200, body)

      _ ->
        conn
        |> send_resp(400, "missing `key` parameter")
    end
  end

  post "/" do
    case conn.params do
      %{"key" => key} ->
        body =
          Incremnet.Server.increment(key)
          |> to_string()

        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, body)

      _ ->
        conn
        |> send_resp(400, "missing `key` parameter")
    end
  end

  match _ do
    send_resp(conn, 404, "no such route: #{conn.method} #{conn.request_path}")
  end
end
