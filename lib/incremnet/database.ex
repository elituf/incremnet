defmodule Incremnet.Database do
  require Logger
  use GenServer

  @db_path "./incremnet_db"

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    schedule_save()
    Logger.info("Starting incremnet database")
    {:ok, nil, {:continue, :load}}
  end

  @impl true
  def handle_continue(:load, state) do
    Logger.info("Loading local database to ETS table")

    case File.read(@db_path) do
      {:ok, ""} ->
        Logger.info("Did not load local database to ETS table")

      {:ok, contents} ->
        :ets.insert(Incremnet.Server, :erlang.binary_to_term(contents))
        Logger.info("Loaded local database to ETS table")

      _ ->
        Logger.info("Did not load local database to ETS table")
    end

    {:noreply, state}
  end

  @impl true
  def handle_info(:save, state) do
    Logger.info("Saving ETS table to local database")
    save()
    Logger.info("Saved ETS table to local database")
    schedule_save()
    {:noreply, state}
  end

  defp save do
    binary =
      :ets.tab2list(Incremnet.Server)
      |> :erlang.term_to_binary()

    File.write!(@db_path, binary)
  end

  defp schedule_save do
    Process.send_after(self(), :save, Application.fetch_env!(:incremnet, :database_save_interval))
  end
end
