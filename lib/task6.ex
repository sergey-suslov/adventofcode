defmodule Task6 do
  defp find_start(letters, len) do
    span = Enum.take(letters, len)

    Enum.reduce_while(Enum.drop(letters, len) |> Enum.with_index(), span, fn {e, i}, span ->
      if Enum.uniq(span) != span, do: {:cont, Enum.drop(span, 1) ++ [e]}, else: {:halt, {span, i}}
    end)
  end

  def solve(str_elems) do
    {s, i} = String.trim(str_elems) |> String.split("", trim: true) |> find_start(4)
    length(s) + i
  end

  def solve_two(str_elems) do
    {s, i} = String.trim(str_elems) |> String.split("", trim: true) |> find_start(14)
    length(s) + i
  end
end
