defmodule AdventOfCode2024.Days.Day03 do
  use AdventOfCode2024.Puzzle

    def part1(input) do
      input
      |> Stream.flat_map(fn l -> Regex.scan(~r/mul\(\d+,\d+\)/, String.trim(l)) |> List.flatten() end)
      |> Stream.map(&operation/1)
      |> Enum.sum()
    end

    def part2(input) do
      input
      |> Stream.flat_map(fn l -> Regex.scan(~r/mul\(\d+,\d+\)|do\(\)|don\'t\(\)/, String.trim(l)) |> List.flatten() end)
      |> Enum.reduce({0, nil}, fn
        "don't()" = new_operator, {res, _operator} -> {res, new_operator}
        "do()" = new_operator, {res, _operator} -> {res, new_operator}
        current_value, {res, operator} when operator in ["do()", nil] -> {res + operation(current_value), operator}
        _, acc -> acc
      end)
      |> elem(0)
    end

    defp operation(op) do
      Module.concat([__MODULE__, op]) |> Code.eval_string() |> elem(0)
    end

    def mul(a, b), do: a * b

  def parse_input(input), do: input
end
