defmodule Incremnet.Plugs.RateLimit do
  use Hammer, backend: :ets, algorithm: :fix_window
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    key = conn.remote_ip
    scale = Keyword.get(opts, :scale, :timer.seconds(60))
    limit = Keyword.get(opts, :limit, 12)

    case hit(key, scale, limit) do
      {:allow, _count} ->
        conn

      {:deny, retry_after} ->
        conn
        |> put_resp_header("retry-after", to_string(div(retry_after, 1000)))
        |> send_resp(429, "rate limit exceeded")
        |> halt()
    end
  end
end
