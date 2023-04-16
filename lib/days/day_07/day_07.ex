defmodule ElixirAoc2022.Day07 do
  @size_limit 100_000

  def parse_input(input) do
    input
    |> String.replace(~r/\$ cd (\w+|\/)/, "$ cd\n\\g{1}")
    |> String.split(~r/\$ cd(\s..)?\n/, trim: true)
    |> Enum.map(&(String.split(&1, ~r/\n\$ ls\n/) |> List.to_tuple()))
    |> Map.new()
  end

  def solve_part_1 do
    input = ElixirAoc2022.Utils.read_input("/lib/days/day_07/input.txt")

    input
    |> parse_input()
  end
end