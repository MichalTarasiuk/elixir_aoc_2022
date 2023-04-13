defmodule ElixirAoc2022.Day05 do
  defp get_input do
    ElixirAoc2022.Utils.read_input("/lib/days/day_05/input.txt")
  end

  defp drop(list, amount) do
    list
    |> Enum.drop(amount)
    |> Enum.drop(-amount)
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

  defp parse_stack_line(line) do
    line
    |> String.split("")
    |> drop(2)
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

  defp parse_input(input) do
    [stacks, procedures] =
      input
      |> String.split("\n\n")

    {parse_stacks(stacks), parse_procedures(procedures)}
  end

  defp move({map, list}) do
    Enum.reduce(list, map, fn {count, from, to}, acc ->
      [stringify_from, stringify_to] = Enum.map([from, to], &Integer.to_string(&1))

      %{^stringify_from => from_list, ^stringify_to => to_list} =
        Map.take(map, [stringify_from, stringify_to])

      {list_part, rest_list} = Enum.split(from_list, count)

      Map.merge(acc, %{
        stringify_from => rest_list,
        stringify_to => Enum.concat([list_part, to_list])
      })
    end)
  end

  def solve_part_1 do
    get_input()
    |> parse_input()
    |> move()
  end
end
