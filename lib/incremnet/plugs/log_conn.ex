defmodule Incremnet.Plugs.LogConn do
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    register_before_send(conn, fn conn ->
      Logger.info(log_line(conn))

      conn
    end)
  end

  defp format_ip(ip), do: ip |> :inet.ntoa() |> to_string()

  defp log_line(conn) do
    status =
      cond do
        not Application.get_env(:elixir, :ansi_enabled, false) ->
          to_string(conn.status)

        conn.status in 200..299 ->
          IO.ANSI.light_green() <> to_string(conn.status) <> IO.ANSI.reset()

        true ->
          IO.ANSI.light_red() <> to_string(conn.status) <> IO.ANSI.reset()
      end

    "Connection | #{format_ip(conn.remote_ip)} #{conn.method} #{conn.request_path} [#{status}]"
  end
end
