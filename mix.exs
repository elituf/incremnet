defmodule Incremnet.MixProject do
  use Mix.Project

  def project do
    [
      app: :incremnet,
      version: "0.3.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:observer, :wx, :runtime_tools, :logger],
      mod: {Incremnet.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      plug_cowboy: "~> 2.0"
    ]
  end
end
