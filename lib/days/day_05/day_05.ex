defmodule ElixirAoc2022.Day05 do
  defp get_input do
    ElixirAoc2022.Utils.read_input("/lib/days/day_05/input.txt")
  end

  defp parse_stack_line(line) do
    line
    |> String.split("")
    |> ElixirAoc2022.Utils.drop(2)
    |> Enum.take_every(4)
    |> Enum.with_index(&{&1, Integer.to_string(&2 + 1)})
    |> Enum.reject(&(elem(&1, 0) === " "))
  end

  defp parse_stacks(stacks) do
    stacks
    |> String.split("\n")
    |> Enum.reverse()
    |> Enum.drop(1)
    |> Enum.flat_map(&parse_stack_line(&1))
    |> Enum.reduce(
      %{},
      &Map.update(&2, elem(&1, 1), [elem(&1, 0)], fn existing_value ->
        [elem(&1, 0) | existing_value]
      end)
    )
  end

  defp parse_procedures(procedures) do
    procedures
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      ~r/^move (\d+) from (\d) to (\d)$/
      |> Regex.run(line, capture: :all_but_first)
      |> Enum.map(&String.to_integer(&1))
      |> then(&List.to_tuple(&1))
    end)
  end

  defp parse_input(input) do
    [stacks, procedures] =
      input
      |> String.split("\n\n")

    {parse_stacks(stacks), parse_procedures(procedures)}
  end

  defp move({map, list}) do
    Enum.reduce(list, map, fn {count, source, dest}, acc ->
      stringify_source = Integer.to_string(source)
      source_list = Map.get(acc, stringify_source)

      {to_move, to_remain} = Enum.split(source_list, count)

      acc
      |> Map.put(stringify_source, to_remain)
      |> Map.update!(Integer.to_string(dest), &Enum.concat([to_move |> Enum.reverse(), &1]))
    end)
  end

  defp get_creates(map) do
    map
    |> Enum.map(fn {_stack_label, [crate | _]} -> crate end)
    |> to_string()
  end

  def solve_part_1 do
    get_input()
    |> parse_input()
    |> move()
    |> get_creates()
  end
end
