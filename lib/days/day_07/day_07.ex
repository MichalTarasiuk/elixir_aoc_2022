defmodule ElixirAoc2022.Day07 do
  @size_limit 100_000

  @file_regexp ~r/(\d+)\s\w+(\.\w+)?/
  @directory_regxp ~r/dir\s(\w+)/

  defp parse_input(input) do
    input
    |> String.replace(~r/\$ cd (\w+|\/)/, "$ cd\n\\g{1}")
    |> String.split(~r/\$ cd(\s..)?\n/, trim: true)
    |> Enum.map(&(String.split(&1, ~r/\n\$ ls\n/) |> List.to_tuple()))
    |> Map.new()
  end

  defp parse_directory_value(directories, directory_value) do
    is_file = String.match?(directory_value, @file_regexp)
    is_directory = String.match?(directory_value, @directory_regxp)

    case true do
      ^is_file ->
        String.replace(directory_value, @file_regexp, "\\g{1}") |> String.to_integer()

      ^is_directory ->
        String.replace(directory_value, ~r/dir\s(\w+)/, "\\g{1}")

      true ->
        0
    end
  end

  defp get_size_of_directories(directories) do
    directories
    |> Map.keys()
    |> Enum.map(fn directory_name ->
      directory_values = Map.fetch!(directories, directory_name)

      directory_values
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_directory_value(directories, &1))
    end)
  end

  def solve_part_1 do
    input = ElixirAoc2022.Utils.read_input("/lib/days/day_07/input.txt")

    input
    |> parse_input()
    |> get_size_of_directories()
  end
end
