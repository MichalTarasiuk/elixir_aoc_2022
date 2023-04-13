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
      |> then(fn [count, from_label, to_label] -> {from_label, to_label, count} end)
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

  def parse_stacks(stacks) do
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

  def solve_part_1 do
    get_input()
    |> parse_input()
  end
end
