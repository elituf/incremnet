1..1_000_000
|> Task.async_stream(fn i ->
  1..100
  |> Enum.map(fn _ ->
    Incremnet.Server.increment("key #{i}")
  end)
end)
|> Enum.to_list()
