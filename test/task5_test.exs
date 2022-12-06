defmodule Task5Test do
  use ExUnit.Case
  doctest Task5

  @spec get_file_stream(charlist()) :: Enumerable.t()
  def get_file_stream(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line) |> Enum.to_list()
  end

  test "test solve small" do
    list_of_str = get_file_stream("test/5_s.txt")

    assert Task5.solve(list_of_str) == "CMZ"
  end

  test "test solve small part two" do
    list_of_str = get_file_stream("test/5_s.txt")

    assert Task5.solve_two(Enum.to_list(list_of_str)) == "MCD"
  end

  test "test solve big" do
    list_of_str = get_file_stream("test/5_b.txt")

    assert Task5.solve(list_of_str) == "VJSFHWGFT"
  end

  test "test solve big part two" do
    list_of_str = get_file_stream("test/5_b.txt")

    assert Task5.solve_two(list_of_str) == 775
  end
end
