defmodule ElixirAoc2022.Day04 do
  defp pair_to_range_tuple(pair) do
    String.split(pair, ",")
    |> Enum.map(&(String.split(&1, "-") |> Enum.map(fn part -> String.to_integer(part) end)))
  end

  defp superset_subset([[a, b], [x, y]]) do
    (a <= x and b >= y) or (a >= x and b <= y)
  end

  defp overlap([[a, b], [x, y]]) do
    not Range.disjoint?(a..b, x..y)
  end

  def solve_part_1 do
    splitted_input = ElixirAoc2022.Utils.get_splitted_input("/lib/days/day_04/input.txt")

    splitted_input
    |> Enum.map(&pair_to_range_tuple(&1))
    |> Enum.count(&superset_subset(&1))
  end

  def solve_part_2 do
    splitted_input = ElixirAoc2022.Utils.get_splitted_input("/lib/days/day_04/input.txt")

    splitted_input
    |> Enum.map(&pair_to_range_tuple(&1))
    |> Enum.count(&overlap(&1))
  end
end
