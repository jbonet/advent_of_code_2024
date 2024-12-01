defmodule AdventOfCode2024.Puzzle do
  @callback parse_input(arg :: File.Stream.t()) :: any
  @callback get_day() :: integer
  @callback run() :: {any, any}
  @callback part1(input :: any) :: any
  @callback part2(input :: any) :: any
  @optional_callbacks part1: 1, part2: 1

  defmacro __using__(_opts) do
    quote do
      @behaviour AdventOfCode2024.Puzzle

      defp get_input() do
        get_file()
        |> File.stream!()
        |> parse_input()
      end

      defp get_file() do
        sample? = Application.get_env(:advent_of_code_2024, :sample_data)

        "inputs/day" <> "#{get_day()}" <> get_extension(sample?)
      end

      defp get_extension(true), do: ".sample" <> get_extension(false)
      defp get_extension(false), do: ".txt"
    end
  end
end
