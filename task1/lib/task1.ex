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

  def solve(str_elems) do
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

    Enum.chunk_while(str_elems, [], chunk_by, after_fun) |> Enum.map(&Enum.sum/1) |> Enum.max()
  end
end
