defmodule ElixirAoc2022.Day02 do
  @win :win
  @draw :draw
  @loss :loss

  @rock :rock
  @paper :paper
  @scissors :scissors

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

  @game_possibilities_without_draw %{
    [@rock, @paper] => @win,
    [@rock, @scissors] => @loss,
    [@paper, @scissors] => @win,
    [@paper, @rock] => @loss,
    [@scissors, @rock] => @win,
    [@scissors, @paper] => @loss
  }

  defp get_round_outcome(opponent_shape, my_shape) do
    if opponent_shape === my_shape,
      do: @draw,
      else: @game_possibilities_without_draw[[opponent_shape, my_shape]]
  end

  defp calculate_my_score(rounds) when is_list(rounds) do
    List.foldl(rounds, 0, fn round, acc ->
      [opponent_shape, my_shape] =
        Enum.map(String.split(round, " "), fn letter_shape ->
          @letter_to_shape[letter_shape |> String.to_atom()]
        end)

      acc + @shape_score[my_shape] +
        @outcome_round_score[get_round_outcome(opponent_shape, my_shape)]
    end)
  end

  def solve_part_1 do
    input = ElixirAoc2022.Utils.read_input("/lib/days/day_02/input.txt")

    input
    |> String.split("\n")
    |> calculate_my_score()
  end
end
