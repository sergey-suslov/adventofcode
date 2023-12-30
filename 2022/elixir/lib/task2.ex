defmodule Task2 do
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

  def parse_into_pairs_desired(str_elems) do
    parse_sym = fn s ->
      case s do
        "A" -> :rock
        "B" -> :paper
        "C" -> :scissors
        "X" -> :loose
        "Y" -> :draw
        "Z" -> :win
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

  defp get_win_pair_from(sym) do
    case sym do
      :rock -> :paper
      :paper -> :scissors
      :scissors -> :rock
    end
  end

  defp get_loose_pair_from(sym) do
    case sym do
      :paper -> :rock
      :scissors -> :paper
      :rock -> :scissors
    end
  end

  defp get_sym_pair({a, d}) do
    case {a, d} do
      {a, :draw} -> a
      {a, :win} -> get_win_pair_from(a)
      {a, :loose} -> get_loose_pair_from(a)
    end
  end

  defp get_game_result_score(r) when r == :win, do: 6
  defp get_game_result_score(r) when r == :draw, do: 3
  defp get_game_result_score(r) when r == :loose, do: 0

  defp calc_game_from_desired({a, d}) do
    get_game_result_score(d) + (get_sym_pair({a, d}) |> get_symbol_score())
  end

  defp calc_game({a, b}) do
    get_game_score({a, b}) + get_symbol_score(b)
  end

  def solve(str_elems) do
    str_elems
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_into_pairs/1)
    |> Enum.map(&calc_game/1)
    |> Enum.sum()
  end

  def solve_two(str_elems) do
    str_elems
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_into_pairs_desired/1)
    |> Enum.map(&calc_game_from_desired/1)
    |> Enum.sum()
  end
end
