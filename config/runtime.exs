import Config

config :incremnet,
  http_port:
    System.get_env("INCREMNET_HTTP_PORT", "34567")
    |> String.to_integer(),
  database_save_interval:
    :timer.seconds(60)
