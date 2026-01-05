defmodule Tools do
  def json_import(path) do
    list = File.read!(path)
    |> JSON.decode!()
    |> Map.to_list()

    :ets.insert(Incremnet.Server, list)
  end

  def json_export(path) do
    json = :ets.tab2list(Incremnet.Server)
    |> Map.new()
    |> JSON.encode!()

    File.write!(path, json)
  end
end
