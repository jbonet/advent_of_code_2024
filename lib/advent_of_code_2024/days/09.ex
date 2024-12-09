defmodule AdventOfCode2024.Days.Day09 do
  use AdventOfCode2024.Puzzle

  def part1(input) do
    input
    |> to_blocks()
    |> compact()
    |> checksum()
  end

  def part2(input) do
    block = input |> to_blocks()

    block
    |> get_files()
    |> compact_files(block)
    |> checksum()
  end

  defp checksum(block) do
    block
    |> Stream.with_index()
    |> Stream.map(fn
      {nil, _} -> 0
      {block_content, block_id} -> block_content * block_id
    end)
    |> Enum.sum()
  end

  defp get_files(block, last_content \\ nil, result \\ [])
  defp get_files([], last_content, result), do: [last_content | result]
  defp get_files([content | block], nil, result), do: get_files(block, {content, 1}, result)
  defp get_files([nil | block], last_content, result), do: get_files(block, last_content, result)

  defp get_files([content | block], {last_value, count} = last_content, result) do
    {new_content, new_result} =
      if content != last_value do
        {{content, 1}, [last_content | result]}
      else
        {{content, count + 1}, result}
      end

    get_files(block, new_content, new_result)
  end

  defp compact_files([], block), do: block

  defp compact_files([{file, size} | rest], block) do
    new_block =
      case get_first_free_block_of_size_or_greater(block, size) do
        nil ->
          block

        free_block ->
          do_compact_file(
            {file, size, Enum.find_index(block, fn x -> x == file end)},
            free_block,
            block
          )
      end

    compact_files(rest, new_block)
  end

  defp do_compact_file({_file, _size, file_index}, {free_block_start, _free_block_size}, block)
       when free_block_start > file_index,
       do: block

  defp do_compact_file({file, size, _file_index}, {free_block_start, free_block_size}, block) do
    before_free_block = Enum.slice(block, 0..(free_block_start - 1))

    after_free_block =
      block
      |> Enum.slice((free_block_start + free_block_size)..(length(block) - 1))
      |> Enum.map(fn
        ^file -> nil
        x -> x
      end)

    new_file_block = Enum.map(0..(size - 1), fn _ -> file end)

    new_free_block =
      if free_block_size - size <= 0,
        do: [],
        else: Enum.map(0..(free_block_size - size - 1), fn _ -> nil end)

    before_free_block ++ new_file_block ++ new_free_block ++ after_free_block
  end

  defp get_first_free_block_of_size_or_greater(block, size) do
    get_first_free_block_of_size_or_greater(block, size, 0, 0)
  end

  defp get_first_free_block_of_size_or_greater([], _size, _offset, _current_size), do: nil

  defp get_first_free_block_of_size_or_greater([nil | rest], size, offset, current_size) do
    get_first_free_block_of_size_or_greater(rest, size, offset + 1, current_size + 1)
  end

  defp get_first_free_block_of_size_or_greater([_ | rest], size, offset, current_size) do
    if current_size >= size do
      {offset - current_size, current_size}
    else
      get_first_free_block_of_size_or_greater(rest, size, offset + 1, 0)
    end
  end

  defp compact(blocks) do
    compact(blocks, Enum.reverse(blocks))
  end

  defp compact(block, [nil | rest]) do
    [_last | rest_block] = Enum.reverse(block)

    compact(Enum.reverse(rest_block), rest)
  end

  defp compact(block, [check_value | rest]) do
    if compact?(block) do
      block |> Enum.reject(&is_nil/1)
    else
      first_free = Enum.find_index(block, &is_nil/1)

      new_block =
        Enum.slice(block, 0..(first_free - 1)) ++
          [check_value] ++ Enum.slice(block, (first_free + 1)..(length(block) - 2))

      compact(new_block, rest)
    end
  end

  defp compact?([first | rest]) do
    {_last_value, result} =
      Enum.reduce_while(rest, {first, true}, fn current_value, {last_value, compact} ->
        if last_value == nil and current_value != nil do
          {:halt, {current_value, false}}
        else
          {:cont, {current_value, compact}}
        end
      end)

    result
  end

  defp to_blocks(disk_map) do
    disk_map
    |> Stream.chunk_every(2, 2, [0])
    |> Stream.with_index()
    |> Enum.flat_map(fn {[block_size, free_after_block], block_id} ->
      block = List.duplicate(block_id, block_size)
      free_space = List.duplicate(nil, free_after_block)
      block ++ free_space
    end)
  end

  def parse_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Stream.flat_map(&Enum.map(&1, fn x -> String.to_integer(x) end))
    |> Enum.to_list()
  end
end
