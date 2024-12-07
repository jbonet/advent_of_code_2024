defmodule AdventOfCode2024.Days.Day07 do
  use AdventOfCode2024.Puzzle

  def part1(input) do
    check_equation(input, ["*", "+"])
  end

  def part2(input) do
    check_equation(input, ["*", "+", "||"])
  end

  def check_equation(equations, symbols, result \\ 0)
  def check_equation([], symbols, result), do: result

  def check_equation([equation | rest], symbols, result) do
    eq_result = do_check_equation(equation, symbols)

    check_equation(rest, symbols, eq_result + result)
  end

  def do_check_equation({_result, numbers} = equation, symbols) do
    operations =
      generate_operations(symbols, length(numbers) - 1)

    try_operations(equation, operations)
  end

  def try_operations(_, []), do: 0

  def try_operations({result, operands} = equation, [operators | rest]) do
    if do_try_operations(equation, operators) == result do
      result
    else
      try_operations(equation, rest)
    end
  end

  def do_try_operations({result, operations}, operators) do
    [first | rest] =
      operations
      |> Enum.zip(operators ++ [nil])
      |> Enum.flat_map(fn
        {element, nil} -> [element]
        {element, symbol} -> [element, symbol]
      end)

    rest
    |> Enum.chunk_every(2)
    |> Enum.reduce_while(first, fn [op, num], acc ->
      new_res =
        case op do
          "+" -> acc + num
          "*" -> acc * num
          "||" -> [acc, num] |> Enum.join() |> String.to_integer()
        end

      if new_res > result do
        {:halt, new_res}
      else
        {:cont, new_res}
      end
    end)
  end

  def generate_operations(symbols, length) do
    generate_combinations(symbols, length, [])
  end

  defp generate_combinations(_symbols, 0, acc), do: [Enum.reverse(acc)]

  defp generate_combinations(symbols, length, acc) do
    for symbol <- symbols do
      generate_combinations(symbols, length - 1, [symbol | acc])
    end
    |> Enum.concat()
  end

  def parse_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ":"))
    |> Stream.map(fn [result, operands] ->
      parsed_operands =
        operands |> String.trim() |> String.split(" ") |> Enum.map(&String.to_integer/1)

      {String.to_integer(result), parsed_operands}
    end)
    |> Enum.to_list()
  end
end
