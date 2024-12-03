defmodule AdventOfCode2024.Days.Day03 do
  use AdventOfCode2024.Puzzle

  def part1(input) do
    input
    |> Stream.flat_map(fn l -> Regex.scan(~r/mul\(\d+,\d+\)/, String.trim(l)) |> List.flatten() end)
    |> get_result()
  end

  def part2(input) do
    input
    |> Stream.flat_map(fn l -> Regex.scan(~r/mul\(\d+,\d+\)|do\(\)|don\'t\(\)/, String.trim(l)) |> List.flatten() end)
    |> Enum.reduce({[], nil}, fn
      "don't()" = new_operator, {valid_operations, _operator} -> {valid_operations, new_operator}
      "do()" = new_operator, {valid_operations, _operator} -> {valid_operations, new_operator}
      current_value, {valid_operations, operator} when operator in ["do()", nil] -> {[current_value | valid_operations], operator}
      _, acc -> acc
    end)
    |> elem(0)
    |> get_result()
  end

  defp get_result(operations) do
    operations
    |> Stream.map(fn op -> Code.eval_string(Module.concat([__MODULE__, op])) |> elem(0) end)
    |> Enum.sum()
  end

  def mul(a, b), do: a * b

  def parse_input(input), do: input
end
