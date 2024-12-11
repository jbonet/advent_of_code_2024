defmodule AdventOfCode2024.Days.Day11 do
  use AdventOfCode2024.Puzzle

  def part1(input) do
    1..25
    |> Enum.reduce(input, fn x, acc -> blink(acc) end)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(input) do
    1..75
    |> Enum.reduce(input, fn x, acc -> blink(acc) end)
    |> Map.values()
    |> Enum.sum()
  end

  def blink(stones) do
    stones
    |> Enum.reduce(%{}, fn {stone, count} = x, acc ->
      case do_blink(stone) do
        {a, b} ->
          acc
          |> Map.update(a, count, &(&1 + count))
          |> Map.update(b, count, &(&1 + count))

        a ->
          Map.update(acc, a, count, &(&1 + count))
      end
    end)
  end

  def do_blink(0), do: 1

  def do_blink(stone) do
    digits = Integer.digits(stone)

    if digits |> length() |> rem(2) == 0 do
      split_stone(digits)
    else
      2024 * stone
    end
  end

  def split_stone(stone) do
    stone_digits = length(stone)
    midpoint = div(stone_digits, 2)

    {a, b} = Enum.split(stone, midpoint)
    {Integer.undigits(a), Integer.undigits(b)}
  end

  def parse_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Enum.flat_map(&String.split(&1, " ", trim: true))
    |> Stream.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end
end
