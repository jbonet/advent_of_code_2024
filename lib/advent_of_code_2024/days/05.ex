defmodule AdventOfCode2024.Days.Day05 do
  use AdventOfCode2024.Puzzle

  def part1({rules, updates}) do
    updates
    |> Stream.map(fn update -> {check_valid(rules, update), update} end)
    |> Stream.reject(fn {valid?, _} -> valid? == false end)
    |> Stream.map(fn {_, update} -> Enum.at(update, floor(length(update) / 2)) end)
    |> Enum.sum()
  end

  def part2({rules, updates}) do
    updates
    |> Stream.map(fn update -> {check_valid(rules, update), update} end)
    |> Stream.reject(fn {valid?, _} -> valid? end)
    |> Stream.map(fn {_, update} -> reorder(rules, update) end)
    |> Stream.map(fn update -> Enum.at(update, floor(length(update) / 2)) end)
    |> Enum.sum()
  end

  defp check_valid(rules, update, previous \\ [])
  defp check_valid(_rules, [], _previous), do: true

  defp check_valid(rules, [current | rest], previous) do
    if Enum.any?(Map.get(rules, current, []), fn x -> x in previous end) do
      false
    else
      check_valid(rules, rest, [current | previous])
    end
  end

  defp reorder(rules, update, final_order \\ [])

  defp reorder(rules, [], final_order) do
    if check_valid(rules, final_order), do: final_order, else: reorder(rules, final_order)
  end

  defp reorder(rules, [current | rest], final_order) do
    current_rules = Map.get(rules, current, [])

    new_result =
      if Enum.empty?(current_rules) or not Enum.any?(current_rules, fn x -> x in final_order end) do
        final_order ++ [current]
      else
        List.insert_at(final_order, get_first_index(current_rules, final_order), current)
      end

    reorder(rules, rest, new_result)
  end

  defp get_first_index([], _values), do: nil

  defp get_first_index([rule | rest], values) do
    index = Enum.find_index(values, fn x -> x == rule end)

    if is_nil(index), do: get_first_index(rest, values), else: index
  end

  def parse_input(input) do
    {_, rules, updates} =
      Enum.reduce(input, {:rules, [], []}, fn line, acc ->
        line |> String.trim() |> parse_line(acc)
      end)

    rules =
      Enum.reduce(rules, %{}, fn {a, b}, acc ->
        Map.update(acc, a, [b], fn x -> [b | x] end)
      end)

    {rules, updates}
  end

  def parse_line("", {_mode, rules, updates}), do: {:updates, rules, updates}

  def parse_line(line, {:rules, rules, updates}) do
    parsed_rules = line |> String.split("|") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

    {:rules, [parsed_rules | rules], updates}
  end

  def parse_line(line, {:updates, rules, updates}) do
    parsed_updates = line |> String.split(",") |> Enum.map(&String.to_integer/1)

    {:updates, rules, [parsed_updates | updates]}
  end
end
