defmodule Task3 do
  defp get_score_map() do
    %{
      "a" => 1,
      "b" => 2,
      "c" => 3,
      "d" => 4,
      "e" => 5,
      "f" => 6,
      "g" => 7,
      "h" => 8,
      "i" => 9,
      "j" => 10,
      "k" => 11,
      "l" => 12,
      "m" => 13,
      "n" => 14,
      "o" => 15,
      "p" => 16,
      "q" => 17,
      "r" => 18,
      "s" => 19,
      "t" => 20,
      "u" => 21,
      "v" => 22,
      "w" => 23,
      "x" => 24,
      "y" => 25,
      "z" => 26,
      "A" => 27,
      "B" => 28,
      "C" => 29,
      "D" => 30,
      "E" => 31,
      "F" => 32,
      "G" => 33,
      "H" => 34,
      "I" => 35,
      "J" => 36,
      "K" => 37,
      "L" => 38,
      "M" => 39,
      "N" => 40,
      "O" => 41,
      "P" => 42,
      "Q" => 43,
      "R" => 44,
      "S" => 45,
      "T" => 46,
      "U" => 47,
      "V" => 48,
      "W" => 49,
      "X" => 50,
      "Y" => 51,
      "Z" => 52
    }
  end

  defp in_pairs(line) do
    m = div(String.length(line), 2)

    {a, b} = String.split_at(line, m)
    {String.split(a, "", trim: true), String.split(b, "", trim: true)}
  end

  defp find_common_items({a, b}) do
    MapSet.intersection(MapSet.new(a), MapSet.new(b)) |> Enum.to_list()
  end

  defp calculate_score(list) do
    map = get_score_map()
    Enum.map(list, &map[&1]) |> Enum.sum()
  end

  def solve(str_elems) do
    Enum.map(str_elems, &in_pairs/1)
    |> Enum.map(&find_common_items/1)
    |> Enum.map(&calculate_score/1)
    |> Enum.sum()
  end

  defp find_common_item([a, b, c]) do
    MapSet.intersection(MapSet.new(a), MapSet.new(b))
    |> MapSet.intersection(MapSet.new(c))
    |> Enum.to_list()
  end

  def solve_two(str_elems) do
    Enum.map(str_elems, &String.split(&1, "", trim: true))
    |> Enum.chunk_every(3)
    |> Enum.map(&find_common_item/1)
    |> Enum.map(&calculate_score/1)
    |>Enum.sum()
  end
end
