defmodule Task1Test do
  use ExUnit.Case
  doctest Task1

  @spec get_file_stream(charlist()) :: Enumerable.t()
  def get_file_stream(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line)
  end

  @spec get_ints_from_file(charlist()) :: list()
  def get_ints_from_file(filename) do
    get_file_stream(filename)
    |> Enum.filter(fn e -> e != "\n" end)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.to_list()
  end

  test "parse file" do
    list_of_nums = get_ints_from_file("test/s.txt")

    assert list_of_nums == [
             1000,
             2000,
             3000,
             4000,
             5000,
             6000,
             7000,
             8000,
             9000,
             10000
           ]
  end

  test "test solve small" do
    list_of_str = get_file_stream("test/s.txt")

    assert Task1.solve(list_of_str) == 24000
  end

  test "test solve big" do
    list_of_str = get_file_stream("test/b.txt")

    assert Task1.solve(list_of_str) == 72017
  end
end
