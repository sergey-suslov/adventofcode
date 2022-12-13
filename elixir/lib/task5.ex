defmodule Task5 do
  defp parse_stacks(str_lines) do
    [h | rows] =
      Enum.take_while(str_lines, fn l -> l != "\n" end)
      |> Enum.map(&String.replace(&1, "\n", ""))
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.chunk_every(&1, 4))
      |> Enum.map(&Enum.map(&1, fn n -> List.pop_at(n, 1) end))
      |> Enum.reverse()

    stacks =
      for num <- 0..(length(h) - 1) do
        Enum.reduce(rows, [], fn row, acc ->
          e = Enum.at(row, num) |> (&elem(&1, 0)).()

          case e do
            " " ->
              acc

            e ->
              [e | acc]
          end
        end)
      end

    stacks
  end

  defp parse_actions(str_lines) do
    divider_line = Enum.find_index(str_lines, fn s -> s == "\n" end)

    Enum.slice(str_lines, (divider_line + 1)..length(str_lines))
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.replace(&1, "move ", ""))
    |> Enum.map(&String.replace(&1, "from ", ""))
    |> Enum.map(&String.replace(&1, "to ", ""))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [n, f, t] ->
      {String.to_integer(n), String.to_integer(f), String.to_integer(t)}
    end)
  end

  defp apply_action(stacks, {num, from, to}) do
    {taken, rest} = Enum.at(stacks, from - 1) |> Enum.split(num)

    for {s, i} <- Enum.with_index(stacks) do
      cond do
        i == to - 1 -> Enum.reverse(taken) ++ s
        i == from - 1 -> rest
        true -> s
      end
    end
  end

  defp apply_action_no_reverse(stacks, {num, from, to}) do
    {taken, rest} = Enum.at(stacks, from - 1) |> Enum.split(num)

    for {s, i} <- Enum.with_index(stacks) do
      cond do
        i == to - 1 -> taken ++ s
        i == from - 1 -> rest
        true -> s
      end
    end
  end

  def solve(str_elems) do
    Enum.reduce(parse_actions(str_elems), parse_stacks(str_elems), fn action, stacks ->
      apply_action(stacks, action)
    end)
    |> Enum.map(&List.first/1)
    |> Enum.join()
  end

  def solve_two(str_elems) do
    Enum.reduce(parse_actions(str_elems), parse_stacks(str_elems), fn action, stacks ->
      apply_action_no_reverse(stacks, action)
    end)
    |> Enum.map(&List.first/1)
    |> Enum.join()
  end
end
