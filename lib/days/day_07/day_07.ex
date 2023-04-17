defmodule ElixirAoc2022.Day07 do
  @size_limit 100_000

  @file_regexp ~r/(\d+)\s\w+(\.\w+)?/
  @directory_regexp ~r/dir\s(\w+)/

  @initial_path ""

  @move_back_cmd_regexp ~r/(\/\w+$)/
  @move_forward_cmd_regexp ~r/^\$ cd (\/|(\w+))$/
  @move_back_cmd "$ cd .."

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

  def parse_input do
    splitted_input = ElixirAoc2022.Utils.get_splitted_input("/lib/days/day_07/input.txt")

    splitted_input
    |> Enum.reduce({@initial_path, %{}}, fn element, {path, directories} ->
      forward_path = move_forward(path, element)
      back_path = move_back(path)

      cond do
        element == @move_back_cmd ->
          {back_path, Map.put_new(directories, back_path, [])}

        is_move_forward_cmd(element) ->
          {forward_path, Map.put_new(directories, forward_path, [])}

        true ->
          {path, directories}
      end
    end)
  end
end
