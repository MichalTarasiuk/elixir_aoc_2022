defmodule ElixirAoc2022.Utils do
  def read_input(path) do
    File.read!(File.cwd!() <> path)
  end

  def get_splitted_input(path) do
    splitted_input = read_input(path)

    splitted_input
    |> String.split("\n")
  end
end
