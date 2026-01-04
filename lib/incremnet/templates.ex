defmodule Incremnet.Templates do
  require EEx

  EEx.function_from_file(:def, :badge, "templates/badge.html", [:key, :value, :image])
end
