defmodule Task3Test do
  use ExUnit.Case
  doctest Task3

  @spec get_file_stream(charlist()) :: Enumerable.t()
  def get_file_stream(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line) |> Enum.to_list() |> Enum.map(&String.trim/1)
  end

  test "test solve small" do
    list_of_str = get_file_stream("test/3_s.txt")

    assert Task3.solve(list_of_str) == 157
  end

  # test "test solve small part two" do
  #   list_of_str = get_file_stream("test/3_s.txt")

  #   assert Task3.solve_two(Enum.to_list(list_of_str)) == 13
  # end

  test "test solve big" do
    list_of_str = get_file_stream("test/3_b.txt")

    assert Task3.solve(list_of_str) == 7980
  end

  # test "test solve big part two" do
  #   list_of_str = get_file_stream("test/3_b.txt")

  #   assert Task3.solve_two(list_of_str) == 212520
  # end
end
