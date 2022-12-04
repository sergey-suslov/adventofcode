defmodule Task4Test do
  use ExUnit.Case
  doctest Task4

  @spec get_file_stream(charlist()) :: Enumerable.t()
  def get_file_stream(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line) |> Enum.to_list() |> Enum.map(&String.trim/1)
  end

  test "test solve small" do
    list_of_str = get_file_stream("test/4_s.txt")

    assert Task4.solve(list_of_str) == 2
  end

  test "test solve small part two" do
    list_of_str = get_file_stream("test/4_s.txt")

    assert Task4.solve_two(Enum.to_list(list_of_str)) == 4
  end

  test "test solve big" do
    list_of_str = get_file_stream("test/4_b.txt")

    assert Task4.solve(list_of_str) == 496
  end

  test "test solve big part two" do
    list_of_str = get_file_stream("test/4_b.txt")

    assert Task4.solve_two(list_of_str) == 775
  end
end
