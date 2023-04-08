defmodule ElixirAoc2022.Day01.Part2 do
  def read do
    File.read!(File.cwd!() <> "/lib/days/day_01/input.txt")
  end

  def string_to_integer(str) do
    parse_result = Integer.parse(str)

    cond do
      is_tuple(parse_result) ->
        elem(parse_result, 0)

      true ->
        0
    end
  end

  def solve do
    input = read()

    input
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.flat_map(fn x ->
      if x === [""],
        do: [],
        else: [
          Enum.map(x, &string_to_integer(&1)) |> Enum.sum()
        ]
    end)
    |> Enum.max()
  end
end
