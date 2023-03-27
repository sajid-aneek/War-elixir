defmodule War do
  @doc """
  The main module to the challenge.
  This module exposes a deal/1 function to play the game.
  """

  @ace_rank 14

  def deal(shuf) do
    {p1, p2} = shuf |> Enum.chunk_every(2) |> Enum.reverse()

    {Enum.reverse(p1), Enum.reverse(p2)}
    |> case do
      {p1, p2} -> game_loop(p1, p2, [])
    end
  end

  defp game_loop(p1, p2, tied) do
    case {p1, p2, tied} do
      {[], [], _} ->
        tied |> Enum.sort_by(&elem(&1, 1), :desc) |> Enum.map(&value_revert/1)

      {[], _, _} ->
        p2 ++ tied |> Enum.sort_by(&elem(&1, 1), :desc) |> Enum.map(&value_revert/1)

      {_, [], _} ->
        p1 ++ tied |> Enum.sort_by(&elem(&1, 1), :desc) |> Enum.map(&value_revert/1)

      {[x | xs], [y | ys], _} ->
        cards = [x, y] ++ tied |> Enum.sort_by(&elem(&1, 1), :desc)

        case compare_cards(x, y) do
          :gt ->
            game_loop(xs ++ cards, ys, [])

          :lt ->
            game_loop(xs, ys ++ cards, [])

          :eq ->
            if xs != [] and ys != [] do
              [fc_down1 | xs] = xs
              [fc_down2 | ys] = ys
              game_loop(xs, ys, cards ++ [fc_down1, fc_down2])
            else
              game_loop(xs, ys, cards)
            end
        end
    end
  end

  defp compare_cards({x, x_rank}, {y, y_rank}) do
    cond do
      x_rank > y_rank -> :gt
      x_rank < y_rank -> :lt
      true -> :eq
    end
  end

  defp value_revert({card, _}) do
    card
  end
end
