defmodule Incremnet.Assets do
  @bg_key {__MODULE__, :badge_background}

  def load do
    encoded = File.read!("assets/bg.png") |> Base.encode64()
    :persistent_term.put(@bg_key, encoded)
  end

  def badge_background do
    :persistent_term.get(@bg_key)
  end
end
