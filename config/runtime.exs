import Config
import Dotenvy

source!([
  Path.absname(".env"),
  System.get_env()
])

database_path =
  case config_env() do
    :prod -> "./incremnet_db/prod"
    :dev -> "./incremnet_db/dev"
    :test -> "./incremnet_db/test"
  end

config :incremnet,
  database_save_interval: :timer.seconds(60),
  database_path: database_path,
  http_port: env!("HTTP_PORT") |> String.to_integer(),
  admin_token: env!("ADMIN_TOKEN")
