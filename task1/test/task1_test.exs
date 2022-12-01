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
    |> Enum.map(&String.trim/1)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.to_list()
  end

  test "parse file" do
    list_of_nums =
      get_ints_from_file("test/s.txt")

    assert list_of_nums == [1000, 2000, 3000]
  end
end
