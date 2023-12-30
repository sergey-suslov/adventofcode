defmodule Task7Test do
  use ExUnit.Case
  doctest Task7

  @spec get_file_stream(charlist()) :: Enumerable.t()
  def get_file_stream(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line) |> Enum.to_list()
  end

  defp get_default_file_root() do
    %ElfFile{
      name: "/",
      type: :dir,
      size: 0,
      dir_path: [],
      files: [
        %ElfFile{
          name: "b",
          type: :dir,
          size: 0,
          dir_path: ["/"],
          files: [
            %ElfFile{
              name: "c",
              type: :dir,
              size: 0,
              dir_path: ["/", "b"],
              files: []
            },
            %ElfFile{
              name: "d",
              type: :file,
              size: 10,
              dir_path: ["/", "b"],
              files: []
            }
          ]
        }
      ]
    }
  end

  test "test file search" do
    root = get_default_file_root()

    expected = %ElfFile{
      name: "d",
      type: :file,
      size: 10,
      dir_path: ["/", "b"],
      files: []
    }

    found = ElfFile.get_file_at(["/", "b", "d"], root)

    assert found == expected
  end

  test "test file insert" do
    root = get_default_file_root()

    new_file = %ElfFile{
      name: "e",
      type: :file,
      size: 20,
      dir_path: ["/", "b", "c"],
      files: []
    }

    new_root = ElfFile.insert(root, new_file)

    take_files = & &1.files

    assert Enum.find(new_root.files, fn f -> f.name == "b" end)
           |> take_files.()
           |> Enum.find(fn f -> f.name == "c" end)
           |> take_files.()
           |> Enum.find(fn f -> f.name == "e" end) == new_file
  end

  test "test solve small" do
    list_of_str = get_file_stream("test/7_s.txt")

    assert Task7.solve(list_of_str) == 95437
  end

  test "test solve small part two" do
    list_of_str = get_file_stream("test/7_s.txt")

    assert Task7.solve_two(list_of_str) == 24_933_642
  end

  test "test solve big" do
    list_of_str = get_file_stream("test/7_b.txt")

    assert Task7.solve(list_of_str) == 1_243_729
  end

  test "test solve big part two" do
    list_of_str = get_file_stream("test/7_b.txt")

    assert Task7.solve_two(list_of_str) == 4443914
  end
end
