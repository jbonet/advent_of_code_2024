defmodule AdventOfCode2024.Runner do
  require Logger

  def run(:all), do: run_all(Application.get_env(:advent_of_code_2024, :sample_data))
  def run(_), do: run_today(Application.get_env(:advent_of_code_2024, :sample_data))

  defp run_all(sample?) do
    Logger.info("#{if sample?, do: "[SAMPLE] "}Executing ALL Puzzles")

    today = get_today()

    Enum.each(1..today, fn day ->
      Logger.info("Day #{day}")

      execute(day)
    end)
  end

  defp run_today(sample?) do
    Logger.info("#{if sample?, do: "[SAMPLE] "}Executing todays Puzzle")
    today = get_today()

    execute(today)
  end

  defp execute(day) do
    {part1, part2} = day |> get_module_name() |> apply(:run, [])

    Logger.info("Result - Part 1: #{part1}, Part 2: #{part2}")
  end

  defp get_module_name(day) do
    day_string = Integer.to_string(day) |> String.pad_leading(2, "0")

    Module.concat(["AdventOfCode2024.Days.Day#{day_string}"])
  end

  defp get_today() do
    today = "Europe/Madrid" |> DateTime.now!() |> DateTime.to_date()

    today.day
  end
end
