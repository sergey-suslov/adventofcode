defmodule Task1 do
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

  def chunk_str_by_spaces(str_elems) do
    parse = fn e ->
      Integer.parse(e) |> (&elem(&1, 0)).()
    end

    chunk_by = fn el, acc ->
      case String.trim(el) do
        "" -> {:cont, acc, []}
        e -> {:cont, [parse.(e) | acc]}
      end
    end

    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, acc, []}
    end

    Enum.chunk_while(str_elems, [], chunk_by, after_fun)
  end

  def solve(str_elems) do
    chunk_str_by_spaces(str_elems) |> Enum.map(&Enum.sum/1) |> Enum.max()
  end

  def solve_two(str_elems) do
    sums = chunk_str_by_spaces(str_elems) |> Enum.map(&Enum.sum/1)

    IO.inspect(sums)

    reduce = fn el, acc ->
      case acc do
        [a, b, c] when c < el -> [a, b, el]
        [a, b, c] when b < el -> [a, el, c]
        [a, b, c] when a < el -> [el, b, c]
        [a, b, c] -> [a, b, c]
        a -> [el | a]
      end
      |> Enum.sort(:desc)
    end

    Enum.reduce(sums, [], reduce) |> IO.inspect() |> Enum.sum()
  end
end
