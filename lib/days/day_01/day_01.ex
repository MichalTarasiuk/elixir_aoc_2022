defmodule ElixirAoc2022.Day01 do
  def read do
    File.read!(File.cwd!() <> "/lib/days/day_01/input.txt")
  end

  def split_input(input) do
    String.split(input, "\n")
  end

  def find_elf_cal(splitted_input) when is_list(splitted_input) do
    acc = List.foldl(splitted_input, %{current: 0, collector: 0}, fn x, acc ->
      %{current: current_value, collector: collector_value} = acc

      parsed_integer = Integer.parse(x)

      if is_tuple(parsed_integer) do
        {integer, _binary} = parsed_integer

        next_current = integer + current_value

        %{current: next_current, collector: collector_value}
      else
        next_collector =
          if current_value > collector_value, do: current_value, else: collector_value

        %{current: 0, collector: next_collector}
      end
    end)

    Map.get(acc, :collector)
  end

  def solve do
    input = read()
    splitted_input = split_input(input)

    find_elf_cal(splitted_input)
  end
end
