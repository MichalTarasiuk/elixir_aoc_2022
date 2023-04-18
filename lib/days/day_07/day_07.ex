defmodule ElixirAoc2022.Day07 do
  @size_limit 100_000

  @file_regexp ~r/(\d+)\s\w+(\.\w+)?/
  @directory_regexp ~r/dir\s(\w+)/

  @initial_path ""

  @move_back_cmd_regexp ~r/(\/\w+$)/
  @move_forward_cmd_regexp ~r/^\$ cd (\/|(\w+))$/
  @move_back_cmd "$ cd .."

  defp is_filename(element) do
    String.match?(element, @file_regexp)
  end

  defp is_directory(element) do
    String.match?(element, @directory_regexp)
  end

  defp is_directory_element(element) do
    is_directory(element) || is_filename(element)
  end

  defp add_prefix(str, prefix) do
    cond do
      String.length(str) != 0 -> "#{prefix}#{str}"
      true -> str
    end
  end

  defp move_back(path) do
    path
    |> String.replace(@move_back_cmd_regexp, "")
  end

  defp is_move_forward_cmd(element) do
    String.match?(element, @move_forward_cmd_regexp)
  end

  defp move_forward(current_path, cmd) do
    name = String.replace(cmd, @move_forward_cmd_regexp, "\\g{2}")

    current_path <> add_prefix(name, "/")
  end

  defp parse_input(splitted_input) do
    splitted_input
    |> Enum.reduce({@initial_path, %{}}, fn element, {path, directories} ->
      forward_path = move_forward(path, element)
      back_path = move_back(path)

      cond do
        element == @move_back_cmd ->
          {back_path, Map.put_new(directories, back_path, [])}

        is_move_forward_cmd(element) ->
          {forward_path, Map.put_new(directories, forward_path, [])}

        is_directory_element(element) ->
          {path, Map.update!(directories, path, &[element | &1])}

        true ->
          {path, directories}
      end
    end)
  end

  defp parse_directory_value(directories, {directory_name, directory_value}) do
    directory_value
    |> Enum.map(fn directory_elemenet ->
      cond do
        is_filename(directory_elemenet) ->
          String.replace(directory_elemenet, @file_regexp, "\\g{1}") |> String.to_integer()

        is_directory(directory_elemenet) ->
          String.replace(directory_elemenet, @directory_regexp, "/\\g{1}")
          |> then(fn next_directory_path ->
            next_directory_name = directory_name <> next_directory_path

            parse_directory_value(
              directories,
              {next_directory_name, Map.get(directories, next_directory_name)}
            )
          end)

        true ->
          0
      end
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  defp parse_directory_values(directories) do
    directories
    |> Enum.map(&{elem(&1, 0), parse_directory_value(directories, &1)})
    |> Map.new()
  end

  defp sum_directories_with_size_limit(directories) do
    directories
    |> Enum.flat_map(fn {_directory_name, directory_value} ->
      if directory_value <= @size_limit, do: [directory_value], else: []
    end)
    |> Enum.sum()
  end

  def solve_part_1 do
    splitted_input = ElixirAoc2022.Utils.get_splitted_input("/lib/days/day_07/input.txt")

    splitted_input
    |> parse_input()
    |> then(&parse_directory_values(elem(&1, 1)))
    |> sum_directories_with_size_limit()
  end
end
