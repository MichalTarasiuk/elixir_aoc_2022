defmodule ElixirAoc2022.Day06 do
  def has_duplicates(list) do
    length(list) != list |> Enum.uniq() |> length()
  end

  def solve_part_1 do
    input = ElixirAoc2022.Utils.read_input("/lib/days/day_06/input.txt")
    splitted_input = String.split(input, "", trim: true)

    splitted_input
    |> Enum.with_index(fn _value, index -> index end)
    |> Enum.find_index(fn index ->
      slice = Enum.slice(splitted_input, (index - 3)..index)

      cond do
        length(slice) == 4 -> not has_duplicates(slice)
        true -> false
      end
    end)
    |> then(&(&1 + 1))
  end
end
