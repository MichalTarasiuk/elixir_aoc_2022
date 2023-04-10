defmodule ElixirAoc2022.Utils do
  def read_input(path) when is_binary(path) do
    File.read!(File.cwd!() <> path)
  end
end
