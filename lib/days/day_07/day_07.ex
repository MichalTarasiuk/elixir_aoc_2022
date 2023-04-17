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
        String.replace(directory_value, @directory_regxp, "\\g{1}")
        |> then(fn directory_name ->
          directory_line = Map.get(directories, directory_name)

          if directory_line, do: parse_directory_values(directories, directory_line), else: 0
        end)

      true ->
        0
    end
  end

  defp parse_directory_values(directories, directory_line) do
    directory_values = String.split(directory_line, "\n", trim: true)

    directory_values
    |> Enum.map(&parse_directory_value(directories, &1))
    |> List.flatten()
    |> Enum.sum()
  end

  defp get_size_of_directories(directories) do
    directories
    |> Map.keys()
    |> Enum.map(fn directory_name ->
      directory_line = Map.fetch!(directories, directory_name)

      directory_line
      |> then(&parse_directory_values(directories, &1))
      |> then(&{directory_name, &1})
    end)
    |> Map.new()
  end

  def solve_part_1 do
    input = ElixirAoc2022.Utils.read_input("/lib/days/day_07/input.txt")

    input
    |> parse_input()
    |> get_size_of_directories()
  end
end
