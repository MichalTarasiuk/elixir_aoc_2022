defmodule ElixirAoc2022.Day02 do
  @win :win
  @draw :draw
  @loss :loss

  @rock :rock
  @paper :paper
  @scissors :scissors

  @rules %{
    @rock => %{
      Z: @paper,
      Y: @rock,
      X: @scissors
    },
    @scissors => %{
      Z: @rock,
      Y: @scissors,
      X: @paper
    },
    @paper => %{
      Z: @scissors,
      Y: @paper,
      X: @rock
    }
  }

  @shape_score %{
    @rock => 1,
    @paper => 2,
    @scissors => 3
  }

  @outcome_round_score %{
    @win => 6,
    @draw => 3,
    @loss => 0
  }

  @letter_to_shape %{
    A: @rock,
    B: @paper,
    C: @scissors,
    X: @rock,
    Y: @paper,
    Z: @scissors
  }

  @shape_to_letter Map.new(@letter_to_shape, fn {key, val} -> {val, key} end)

  @game_possibilities_without_draw %{
    [@rock, @paper] => @win,
    [@rock, @scissors] => @loss,
    [@paper, @scissors] => @win,
    [@paper, @rock] => @loss,
    [@scissors, @rock] => @win,
    [@scissors, @paper] => @loss
  }

  defp rules_to_shape_letters(splitted_input) when is_list(splitted_input) do
    splitted_input
    |> Enum.map(fn element ->
      [opponent_letter_shape, my_letter_shape] = String.split(element, " ")

      opponent_shape = @letter_to_shape[opponent_letter_shape |> String.to_atom()]

      my_shape = @rules[opponent_shape][my_letter_shape |> String.to_atom()]
      my_letter_shape = @shape_to_letter[my_shape]

      "#{opponent_letter_shape} #{my_letter_shape}"
    end)
  end

  defp get_round_outcome(opponent_shape, my_shape) do
    if opponent_shape === my_shape,
      do: @draw,
      else: @game_possibilities_without_draw[[opponent_shape, my_shape]]
  end

  defp calculate_my_score(rounds) when is_list(rounds) do
    List.foldl(rounds, 0, fn round, acc ->
      [opponent_shape, my_shape] =
        Enum.map(String.split(round, " "), &@letter_to_shape[&1 |> String.to_atom()])

      acc + @shape_score[my_shape] +
        @outcome_round_score[get_round_outcome(opponent_shape, my_shape)]
    end)
  end

  def solve_part_1 do
    splitted_input = ElixirAoc2022.Utils.get_splitted_input("/lib/days/day_01/input.txt")

    splitted_input
    |> calculate_my_score()
  end

  def solve_part_2 do
    splitted_input = ElixirAoc2022.Utils.get_splitted_input("/lib/days/day_01/input.txt")

    splitted_input
    |> rules_to_shape_letters()
    |> calculate_my_score()
  end
end
