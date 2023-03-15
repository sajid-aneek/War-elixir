defmodule War do
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function that deals the cards to both players and simulates the game of War.
    Returns the name of the winning player.
  """
  def deal(shuf) do
    {p1, p2} = Enum.split(shuf, 26)
    play(p1, p2, "Player 1")
  end

  def play(p1, p2, winner) do
    case {p1, p2} do
      {[], _} -> "Player 2"
      {_, []} -> "Player 1"
      {[p1_card | p1_tail], [p2_card | p2_tail]} ->
        if p1_card > p2_card do
          play(p1_tail ++ [p1_card, p2_card], p2_tail, winner)
        else if p1_card < p2_card do
          play(p1_tail, p2_tail ++ [p2_card, p1_card], winner)
        else
          play(war(p1_tail, p2_tail, [p1_card], [p2_card]), [], winner)
        end
      end
    end
  end

  def war(p1, p2, war_p1, war_p2) do
    [c1_1, c1_2 | p1_tail] = p1
    [c2_1, c2_2 | p2_tail] = p2
    case {c1_2, c2_2} do
      {nil, nil} -> war(war_p1, war_p2, [c1_1], [c2_1])
      {_, nil} -> p1_tail ++ war_p1 ++ war_p2 ++ [c1_1, c2_1, c1_2]
      {nil, _} -> p2_tail ++ war_p1 ++ war_p2 ++ [c1_1, c2_1, c2_2]
      {c1_2, c2_2} when c1_2 > c2_2 ->
        play(p1_tail ++ war_p1 ++ war_p2 ++ [c1_1, c2_1, c1_2, c2_2], p2_tail, "Player 1")
      {c1_2, c2_2} when c1_2 < c2_2 ->
        play(p1_tail ++ war_p1 ++ war_p2 ++ [c1_1, c2_1, c2_2, c1_2], p2_tail, "Player 2")
      {c1_2, c2_2} -> war(p1_tail, p2_tail, war_p1 ++ [c1_1, c1_2], war_p2 ++ [c2_1, c2_2])
    end
  end
end
