defmodule Incremnet.Database do
  require Logger
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    Application.fetch_env!(:incremnet, :database_path)
    |> Path.dirname()
    |> File.mkdir_p!()

    schedule_save()
    Logger.info("Starting incremnet database")
    {:ok, nil, {:continue, :load}}
  end

  @impl true
  def handle_continue(:load, state) do
    Logger.info("Loading local database to ETS table")

    case Application.fetch_env!(:incremnet, :database_path)
         |> File.read() do
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

    Application.fetch_env!(:incremnet, :database_path)
    |> File.write!(binary)
  end

  defp schedule_save do
    Process.send_after(self(), :save, Application.fetch_env!(:incremnet, :database_save_interval))
  end
end
