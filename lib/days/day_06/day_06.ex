defmodule ElixirAoc2022.Day06 do
  defp has_duplicates(list) do
    length(list) != list |> Enum.uniq() |> length()
  end

  defp find_marker(marker_length) do
    input = ElixirAoc2022.Utils.read_input("/lib/days/day_06/input.txt")
    splitted_input = String.split(input, "", trim: true)

    splitted_input
    |> Enum.with_index(fn _value, index -> index end)
    |> Enum.find_index(fn index ->
      slice = Enum.slice(splitted_input, (index - (marker_length - 1))..index)

      cond do
        length(slice) == marker_length -> not has_duplicates(slice)
        true -> false
      end
    end)
    |> then(&(&1 + 1))
  end

  def solve_part_1 do
    find_marker(4)
  end

  def solve_part_2 do
    find_marker(14)
  end
end
