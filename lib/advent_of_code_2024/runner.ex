defmodule AdventOfCode2024.Runner do
  @callback parse_input(arg :: File.Stream.t()) :: any
  @callback get_day() :: integer
  @callback run(sample? :: boolean) :: any
  @callback part1(input :: any) :: any
  @callback part2(input :: any) :: any
  @optional_callbacks part1: 1, part2: 1

  defmacro __using__(_opts) do
    quote do
      @behaviour AdventOfCode2024.Runner

      defp get_input(sample?) do
        sample?
        |> get_file()
        |> File.stream!()
        |> parse_input()
      end

      defp get_file(sample?) do
        "inputs/day" <> "#{get_day()}" <> get_extension(sample?)
      end

      defp get_extension(true), do: ".sample" <> get_extension(false)
      defp get_extension(false), do: ".txt"
    end
  end
end
