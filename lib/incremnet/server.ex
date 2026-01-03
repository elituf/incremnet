defmodule Incremnet.Server do
  require Logger
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def increment(key) do
    :ets.update_counter(__MODULE__, key, 1, {key, 0})
  end

  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, value}] ->
        value

      [] ->
        :ets.insert(__MODULE__, {key, 0})
        0
    end
  end

  @impl true
  def init(_arg) do
    :ets.new(__MODULE__, [:named_table, :public, write_concurrency: true])
    Logger.info("Started incremnet server")
    {:ok, nil}
  end
end
