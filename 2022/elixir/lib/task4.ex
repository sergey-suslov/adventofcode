defmodule Task4 do
  defp parse_pair(pair_string) do
    pair_to_list = fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end
    String.split(pair_string, "-") |> pair_to_list.()
  end

  defp in_pairs(str_line),
    do: String.split(str_line, ",") |> Enum.map(&parse_pair/1)

  defp contain?({os, of}, {is, if}), do: os <= is and of >= if
  def overlap?({os, of}, {is, if}), do: (os <= is and of >= is) or (os <= if and of >= if)

  def solve(str_elems) do
    Enum.map(str_elems, &in_pairs/1)
    |> Enum.map(fn [a, b] -> contain?(a, b) or contain?(b, a) end)
    |> Enum.map(fn e -> if e, do: 1, else: 0 end)
    |> Enum.sum()
  end

  def solve_two(str_elems) do
    Enum.map(str_elems, &in_pairs/1)
    |> Enum.map(fn [a, b] -> overlap?(a, b) or overlap?(b, a) end)
    |> Enum.map(fn e -> if e, do: 1, else: 0 end)
    |> Enum.sum()
  end
end
