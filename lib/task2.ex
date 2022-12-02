defmodule Task2 do
  @moduledoc """
  Documentation for `Task1`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Task1.hello()
      :world

  """
  def hello do
    :world
  end

  def parse_into_pairs(str_elems) do
    parse_sym = fn s ->
      case s do
        "A" -> :rock
        "B" -> :paper
        "C" -> :scissors
        "X" -> :rock
        "Y" -> :paper
        "Z" -> :scissors
      end
    end

    parse_pair = fn [a, b] -> {parse_sym.(a), parse_sym.(b)} end

    String.split(str_elems)
    |> parse_pair.()
  end

  defp get_symbol_score(symbol) do
    case symbol do
      :rock -> 1
      :paper -> 2
      :scissors -> 3
    end
  end

  defp get_game_score({a, b}) do
    case {a, b} do
      {a, b} when a == b -> 3
      {a, b} when b == :rock and a == :scissors -> 6
      {a, b} when b == :scissors and a == :paper -> 6
      {a, b} when b == :paper and a == :rock -> 6
      {_, _} -> 0
    end
  end

  defp calc_game({a, b}) do
    get_game_score({a, b}) + get_symbol_score(b)
  end

  def solve(str_elems) do
    str_elems
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_into_pairs/1)
    |> Enum.map(&calc_game/1)
    |> IO.inspect()
    |> Enum.sum()
  end

  def solve_two(str_elems) do
  end
end
