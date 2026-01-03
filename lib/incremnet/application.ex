defmodule Incremnet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  require Logger

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Incremnet.Worker.start_link(arg)
      Incremnet.Server,
      Incremnet.Database
    ]

    Logger.info("Starting supervisor")
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Incremnet.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
