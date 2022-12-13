defmodule Task8Test do
  use ExUnit.Case
  doctest Task8

  @spec get_file_stream(charlist()) :: Enumerable.t()
  def get_file_stream(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line) |> Enum.to_list()
  end

  test "test solve small" do
    list_of_str = get_file_stream("test/8_s.txt")

    assert Task8.solve(list_of_str) == 21
  end

  test "test solve small part two" do
    list_of_str = get_file_stream("test/8_s.txt")

    assert Task8.solve_two(list_of_str) == 8
  end

  test "test solve big" do
    list_of_str = get_file_stream("test/8_b.txt")

    assert Task8.solve(list_of_str) == 1812
  end

  test "test solve big part two" do
    list_of_str = get_file_stream("test/8_b.txt")

    assert Task8.solve_two(list_of_str) == 4_443_914
  end
end
