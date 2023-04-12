defmodule ElixirAoc2022.Day03 do
  @letters "abcdefghijklmnopqrstuvwxyz" |> String.split("", trim: true)

  @letter_to_point Map.new(
                     @letters
                     |> Enum.with_index(&{&1, &2 + 1})
                     |> Enum.flat_map(fn {letter, index} ->
                       [{letter, index}, {String.upcase(letter), index + length(@letters)}]
                     end)
                   )

  defp intersection_2(list1, list2) do
    m1 = MapSet.new(list1)
    m2 = MapSet.new(list2)

    MapSet.intersection(m1, m2) |> MapSet.to_list()
  end

  defp intersection(lists) do
    {acc, other_lists} = List.pop_at(lists, 0, [])

    List.foldl(other_lists, acc, &intersection_2(&1, &2))
  end

  def solve_part_1 do
    splitted_input = ElixirAoc2022.Utils.get_splitted_input("/lib/days/day_03/input.txt")

    List.foldl(splitted_input, 0, fn rucksack, acc ->
      splitted_rucksack = String.split(rucksack, "", trim: true)

      divider = length(splitted_rucksack) |> div(2)

      first_compartment = Enum.slice(splitted_rucksack, 0..(divider - 1))
      second_compartment = Enum.slice(splitted_rucksack, divider..length(splitted_rucksack))

      letter = intersection_2(first_compartment, second_compartment) |> Enum.at(0)

      acc + @letter_to_point[letter]
    end)
  end

  def solve_part_2 do
    splitted_input = ElixirAoc2022.Utils.get_splitted_input("/lib/days/day_03/input.txt")

    splitted_input
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(&Enum.map(&1, fn rucksack -> String.split(rucksack, "", trim: true) end))
    |> Enum.flat_map(&intersection(&1))
    |> List.foldl(0, &(@letter_to_point[&1] + &2))
  end
end
