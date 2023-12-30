defmodule Task8 do
  defp parse_into_map(str_lines) do
    n_size = length(str_lines)

    m_size =
      length(
        Enum.at(str_lines, 0)
        |> String.trim()
        |> String.split("", trim: true)
      )

    map =
      Enum.reduce(Enum.with_index(str_lines), %{}, fn {line, i}, acc ->
        String.trim(line)
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {e, j}, acc -> Map.put(acc, {i, j}, e) end)
      end)

    {map, {n_size, m_size}}
  end

  defp check_cell(map, {n_size, m_size}, {i, j}) do
    height = map[{i, j}]

    hidden_left =
      if j == 0 || j == m_size - 1,
        do: false,
        else: Enum.to_list(0..(j - 1)) |> Enum.any?(fn m -> map[{i, m}] >= height end)

    hidden_right =
      if j == 0 || j == m_size - 1,
        do: false,
        else: Enum.to_list((j + 1)..(m_size - 1)) |> Enum.any?(fn m -> map[{i, m}] >= height end)

    hidden_top =
      if i == 0 || i == n_size - 1,
        do: false,
        else: Enum.to_list(0..(i - 1)) |> Enum.any?(fn m -> map[{m, j}] >= height end)

    hidden_bot =
      if i == 0 || i == n_size - 1,
        do: false,
        else: Enum.to_list((i + 1)..(n_size - 1)) |> Enum.any?(fn m -> map[{m, j}] >= height end)

    {hidden_left, hidden_right, hidden_top, hidden_bot}
  end

  defp calc_scenic_score(map, {n_size, m_size}, {i, j}) do
    height = map[{i, j}]

    score_left =
      if j == 0 || j == m_size - 1,
        do: 0,
        else:
          Enum.reduce(0..(j - 1), [], fn m, acc ->
            case acc do
              [] ->
                [map[{i, m}]]

              acc ->
                if map[{i, m}] > Enum.max(acc) ||
                     (map[{i, m}] >= Enum.max(acc) && map[{i, m}] <= height),
                   do: [map[{i, m}] | acc],
                   else: acc
            end
          end)
          |> Enum.count()

    score_right =
      if j == 0 || j == m_size - 1,
        do: 0,
        else:
          Enum.reduce((j + 1)..(m_size - 1), [], fn m, acc ->
            case acc do
              [] ->
                [map[{i, m}]]

              acc ->
                if map[{i, m}] > Enum.max(acc) ||
                     (map[{i, m}] >= Enum.max(acc) && map[{i, m}] <= height),
                   do: [map[{i, m}] | acc],
                   else: acc
            end
          end)
          |> Enum.count()

    score_top =
      if i == 0 || i == n_size - 1,
        do: 0,
        else:
          Enum.reduce(0..(i - 1), [], fn m, acc ->
            case acc do
              [] ->
                [map[{m, j}]]

              acc ->
                if map[{m, j}] > Enum.max(acc) ||
                     (map[{m, j}] >= Enum.max(acc) && map[{m, j}] <= height),
                   do: [map[{m, j}] | acc],
                   else: acc
            end
          end)
          |> Enum.count()

    score_bot =
      if i == 0 || i == n_size - 1,
        do: 0,
        else:
          Enum.reduce((i + 1)..(n_size - 1), [], fn m, acc ->
            case acc do
              [] ->
                [map[{m, j}]]

              acc ->
                if map[{m, j}] > Enum.max(acc) ||
                     (map[{m, j}] >= Enum.max(acc) && map[{m, j}] <= height),
                   do: [map[{m, j}] | acc],
                   else: acc
            end
          end)
          |> Enum.count()

    {score_left, score_right, score_top, score_bot}
    score_left * score_right * score_top * score_bot
  end

  def solve(str_elems) do
    {map, {n, m}} = parse_into_map(str_elems)

    Enum.map(0..(n - 1), fn i ->
      Enum.map(0..(m - 1), fn j -> check_cell(map, {n, m}, {i, j}) end)
    end)
    |> Enum.reduce([], fn a, acc -> acc ++ a end)
    |> Enum.map(fn {l, r, t, b} -> l && r && t && b end)
    |> Enum.reduce(0, fn hidden, acc -> acc + if hidden, do: 0, else: 1 end)
  end

  def solve_two(str_elems) do
    {map, {n, m}} = parse_into_map(str_elems)

    Enum.map(0..(n - 1), fn i ->
      Enum.map(0..(m - 1), fn j -> calc_scenic_score(map, {n, m}, {i, j}) end) |> Enum.max()
    end)
    |> Enum.max()
  end
end
