defmodule ElfFile do
  defstruct name: nil, type: nil, files: [], parent: nil, size: 0, dir_path: []

  @type t :: %ElfFile{
          name: charlist(),
          type: atom(),
          files: [ElfFile],
          dir_path: charlist(),
          size: integer()
        }
  def new(name, type, dir_path \\ [], files \\ [], size \\ 0) do
    %ElfFile{name: name, type: type, files: files, size: size, dir_path: dir_path}
  end

  @spec full_name(ElfFile.t()) :: [charlist()]
  def full_name(file) do
    file.dir_path ++ [file.name]
  end

  def sum_size(root) do
    case root.type do
      :dir -> Enum.map(root.files, &sum_size/1) |> Enum.sum()
      :file -> root.size
    end
  end

  def get_size(root, path), do: get_file_at(path, root) |> sum_size()

  @doc """
  - root
  -- a
  -- b
    -- c
    -- d
  """
  def insert(root, file), do: insert(root, file.dir_path, file)
  def insert(root, ["/" | rest], file), do: insert(root, rest, file)

  def insert(root, [], file) do
    Map.update(root, :files, [], fn existing_files ->
      Enum.uniq_by(existing_files ++ [file], fn n ->
        n.name
      end)
    end)
  end

  def insert(root, [head | rest], file) do
    Map.update(root, :files, [], fn files ->
      Enum.map(files, fn f ->
        case f.name do
          ^head -> insert(f, rest, file)
          _ -> f
        end
      end)
    end)
  end

  def get_file_at([], root), do: root
  def get_file_at(["/" | rest], root), do: get_file_at(rest, root)

  def get_file_at(path, root) do
    [head | rest] = path

    case Enum.find(root.files, fn f -> f.name == head end) do
      nil -> nil
      f -> get_file_at(rest, f)
    end
  end
end

defmodule Task7 do
  defp get_type_from_line(line) do
    cond do
      String.contains?(line, "$") ->
        {:command, String.replace(line, "$ ", "")}

      !String.contains?(line, "$") ->
        {:print, line}
    end
  end

  defp parse_command(line) do
    [command | args] = String.split(line, " ", trim: true)
    {command, args}
  end

  defp parse_command_result_content(content) do
    [type_size, name] = String.split(content, " ", trim: true)

    case type_size do
      "dir" -> {:dir, name}
      size -> {:file, name, String.to_integer(size)}
    end
  end

  defp parse_instructions(str_lines) do
    chunk_by = fn el, {command, elems} ->
      case get_type_from_line(el) do
        {:command, comm} -> {:cont, {command, elems}, {comm, []}}
        {:print, cont} -> {:cont, {command, [parse_command_result_content(cont) | elems]}}
      end
    end

    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, acc, []}
    end

    Enum.map(str_lines, &String.trim/1)
    |> Enum.chunk_while({:a, []}, chunk_by, after_fun)
    |> Enum.drop(1)
    |> Enum.map(fn {comm, result} -> {parse_command(comm), result} end)
  end

  @spec handle_command(ElfFile.t(), [charlist()], tuple()) :: {ElfFile.t(), [charlist()]}
  defp handle_command(root, position, {command, result}) do
    case command do
      {"cd", [".."]} ->
        {root,
         Enum.reverse(position)
         |> Enum.drop(1)
         |> Enum.reverse()
         |> ElfFile.get_file_at(root)
         |> ElfFile.full_name()}

      {"cd", [arg]} ->
        {root, ElfFile.get_file_at(position ++ [arg], root) |> ElfFile.full_name()}

      {"ls", _} ->
        {Enum.reduce(result, root, fn name, root ->
           case name do
             {:dir, name} ->
               ElfFile.insert(
                 root,
                 ElfFile.new(name, :dir, position, [], 0)
               )

             {:file, name, size} ->
               ElfFile.insert(
                 root,
                 ElfFile.new(name, :file, position, [], size)
               )
           end
         end), position}
    end
  end

  defp traverse_files_sizes(root) when root.type == :file, do: {:size, root.size}

  defp traverse_files_sizes(root) do
    files =
      Enum.reduce(root.files, [], fn f, acc ->
        case traverse_files_sizes(f) do
          {:size, size} -> acc ++ [{ElfFile.full_name(f), {:size, size}}]
          {name, sum, files} -> acc ++ [{name, sum, files}]
        end
      end)

    {ElfFile.full_name(root),
     Enum.map(files, fn f ->
       case f do
         {_, {:size, size}} -> size
         {_, sum, _} -> sum
       end
     end)
     |> Enum.sum(), files}
  end

  defp find_dirs_with_size_less({_, {:size, _}}, _), do: []

  defp find_dirs_with_size_less({path, f_size, children}, size) do
    files =
      Enum.reduce(children, [], fn f, acc ->
        acc ++ find_dirs_with_size_less(f, size)
      end)

    if f_size <= size, do: [{path, f_size}] ++ files, else: files
  end

  defp find_dirs_with_size_greater({_, {:size, _}}, _), do: []

  defp find_dirs_with_size_greater({path, f_size, children}, size) do
    files =
      Enum.reduce(children, [], fn f, acc ->
        acc ++ find_dirs_with_size_greater(f, size)
      end)

    if f_size >= size, do: [{path, f_size}] ++ files, else: files
  end

  def solve(str_elems) do
    root = ElfFile.new("/", :dir)
    instructions = parse_instructions(str_elems) |> Enum.drop(1)

    {root, _} =
      Enum.reduce(instructions, {root, ElfFile.full_name(root)}, fn ins, {root, pos} ->
        handle_command(root, pos, ins)
      end)

    size_table = traverse_files_sizes(root)
    capped_dirs = find_dirs_with_size_less(size_table, 100_000)
    Enum.map(capped_dirs, fn {_, size} -> size end) |> Enum.sum()
  end

  def solve_two(str_elems) do
    root = ElfFile.new("/", :dir)
    instructions = parse_instructions(str_elems) |> Enum.drop(1)

    {root, _} =
      Enum.reduce(instructions, {root, ElfFile.full_name(root)}, fn ins, {root, pos} ->
        handle_command(root, pos, ins)
      end)

    size_table = traverse_files_sizes(root)
    {_, size, _} = size_table
    min_to_delete = 30_000_000 - (70_000_000 - size)

    capped_dirs = find_dirs_with_size_greater(size_table, min_to_delete)
    {_, min_dir_size} = Enum.min_by(capped_dirs, fn {_, size} -> size end)
    min_dir_size
  end
end
