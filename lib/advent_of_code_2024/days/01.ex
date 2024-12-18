defmodule AdventOfCode2024.Days.Day01 do
  use AdventOfCode2024.Puzzle

  def part1({input_A, input_B}) do
    Enum.zip(Enum.sort(input_A), Enum.sort(input_B))
    |> Stream.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2({input_A, input_B}) do
    frequencies = Enum.frequencies(input_B)

    input_A
    |> Stream.map(fn x -> x * Map.get(frequencies, x, 0) end)
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> Stream.map(fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.unzip()
  end
end
