import Config

database_path =
  case config_env() do
    :prod -> "./incremnet_db/prod"
    :dev -> "./incremnet_db/dev"
    :test -> "./incremnet_db/test"
  end

config :incremnet,
  http_port:
    System.get_env("INCREMNET_HTTP_PORT", "34567")
    |> String.to_integer(),
  database_save_interval: :timer.seconds(60),
  database_path: database_path
