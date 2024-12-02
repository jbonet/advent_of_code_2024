defmodule AdventOfCode2024.Days.Day02 do
  use AdventOfCode2024.Puzzle

  def part1(input) do
    check_input(input)
  end

  def part2(input) do
    check_input(input, 0, true)
  end

  def parse_input(input) do
    Enum.map(input, fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
  end

  defp check_input(input, acc \\ 0, dampener \\ false)
  defp check_input([], acc, _), do: acc

  defp check_input([row | rest], acc, dampener) do
    res =
      if dampener, do: check_with_dampener(row), else: check_row(row)

    check_input(rest, acc + res, dampener)
  end

  defp check_with_dampener(input), do: check_with_dampener(input, input)
  defp check_with_dampener(current_input, original_input, next \\ 0)

  defp check_with_dampener(_current_input, original_input, next)
       when next > length(original_input),
       do: 0

  defp check_with_dampener(current_input, original_input, next) do
    case check_row(current_input) do
      1 ->
        1

      _ ->
        new_list = List.delete_at(original_input, next)

        check_with_dampener(new_list, original_input, next + 1)
    end
  end

  defp check_row(row, previous \\ nil, order \\ nil)
  defp check_row([], _previous, _order), do: 1

  defp check_row([current | rest], nil, nil) do
    check_row(rest, current)
  end

  defp check_row([current | _rest] = row, previous, nil) do
    cond do
      current < previous -> check_row(row, previous, :desc)
      current > previous -> check_row(row, previous, :asc)
      current == previous -> 0
    end
  end

  defp check_row([current | rest], previous, :asc) do
    if in_range(abs(previous - current)) and previous < current do
      check_row(rest, current, :asc)
    else
      0
    end
  end

  defp check_row([current | rest], previous, :desc) do
    if in_range(abs(previous - current)) and previous > current do
      check_row(rest, current, :desc)
    else
      0
    end
  end

  defp in_range(value, min \\ 1, max \\ 3) do
    value >= min and value <= max
  end
end
