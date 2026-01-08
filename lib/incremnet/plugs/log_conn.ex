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

  defp log_line(conn),
    do:
      "Connection | #{format_ip(conn.remote_ip)} #{conn.method} #{conn.request_path} [#{conn.status}]"
end
