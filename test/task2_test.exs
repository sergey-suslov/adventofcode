defmodule Task2Test do
  use ExUnit.Case
  doctest Task2

  @spec get_file_stream(charlist()) :: Enumerable.t()
  def get_file_stream(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line) |> Enum.to_list()
  end

  test "test solve small" do
    list_of_str = get_file_stream("test/2_s.txt")

    assert Task2.solve(list_of_str) == 24000
  end

  # test "test solve small part two" do
  #   list_of_str = get_file_stream("test/2_s.txt")

  #   assert Task2.solve_two(Enum.to_list(list_of_str)) == 45000
  # end

  test "test solve big" do
    list_of_str = get_file_stream("test/2_b.txt")

    assert Task2.solve(list_of_str) == 72017
  end

  # test "test solve big part two" do
  #   list_of_str = get_file_stream("test/b.txt")

  #   assert Task2.solve_two(list_of_str) == 212520
  # end
end
