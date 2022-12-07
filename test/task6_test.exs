defmodule Task6Test do
  use ExUnit.Case
  doctest Task6

  @spec get_file_stream(charlist()) :: Enumerable.t()
  def get_file_stream(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line) |> Enum.to_list() |> List.first()
  end

  test "test solve small" do
    list_of_str = get_file_stream("test/6_s.txt")

    assert Task6.solve(list_of_str) == 10
  end

  test "test solve small part two" do
    list_of_str = get_file_stream("test/6_s.txt")

    assert Task6.solve_two(list_of_str) == 29
  end

  test "test solve big" do
    list_of_str = get_file_stream("test/6_b.txt")

    assert Task6.solve(list_of_str) == 1361
  end

  test "test solve big part two" do
    list_of_str = get_file_stream("test/6_b.txt")

    assert Task6.solve_two(list_of_str) == 3263
  end
end
