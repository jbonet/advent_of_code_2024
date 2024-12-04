defmodule AdventOfCode2024.Days.Day04 do
  use AdventOfCode2024.Puzzle

  def part1({values, coordinates}) do
    search(values, coordinates, "part1")
    |> Stream.reject(fn x -> x == [] end)
    |> Enum.to_list()
    |> List.flatten()
    |> dedup()
    |> Enum.count()
  end

  def part2({values, coordinates}) do
    search(values, coordinates, "part2")
    |> Stream.reject(&is_nil/1)
    |> Enum.count()
  end

  defp search(values, coordinates, part, results \\ [])
  defp search(_values, [], _part, results), do: results

  defp search(values, [point | next], part, results) do
    value = get_words(values, point, part)

    search(values, next, part, [value | results])
  end

  defp get_words(values, {x, y}, "part1") do
    [{1, 0}, {1, 1}, {1, -1}, {0, 1}, {0, -1}, {-1, 0}, {-1, 1}, {-1, -1}]
    |> Stream.map(fn vector -> find_words(values, {x, y}, vector) end)
    |> Enum.reject(&is_nil/1)
  end

  defp get_words(values, {x, y}, "part2") do
    find_values = fn vectors ->
      coordinates = Enum.map(vectors, fn {vx, vy} -> {x + vx, y + vy} end)
      values = coordinates |> Enum.map(fn {cx, cy} -> Map.get(values, "#{cx}-#{cy}") end)

      values =
        if Enum.any?(values, &is_nil/1) do
          nil
        else
          values
        end

      if not is_nil(values) and Enum.join(values) in ["SAM", "MAS"] do
        %{coordinates: coordinates, word: values}
      end
    end

    res =
      [
        [{-1, -1}, {0, 0}, {1, 1}] |> find_values.(),
        [{1, -1}, {0, 0}, {-1, 1}] |> find_values.()
      ]

    if Enum.any?(res, &is_nil/1) do
      nil
    else
      true
    end
  end

  defp find_words(values, point, vector, results \\ [])

  defp find_words(_values, _point, _vector, nil), do: nil

  defp find_words(_values, _point, _vector, results) when length(results) == 4,
    do: check_word(results)

  defp find_words(values, {x, y} = point, {vx, vy} = vector, results) do
    current_letter = {point, Map.get(values, "#{x}-#{y}")}

    find_words(
      values,
      {x + vx, y + vy},
      vector,
      if(is_nil(current_letter), do: nil, else: [current_letter | results])
    )
  end

  defp check_word(word) do
    letters = word |> Enum.map(fn {_, letter} -> letter end) |> Enum.join()

    if letters == "XMAS" or letters == "SAMX" do
      %{coordinates: word |> Enum.map(fn {point, _} -> point end)}
    end
  end

  defp dedup(coordinates) do
    coordinates |> Enum.map(fn %{coordinates: c} -> c |> Enum.sort() end) |> Enum.uniq()
  end

  def parse_input(input) do
    parsed_input =
      input
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Enum.to_list()

    size = length(parsed_input)

    data =
      for {row, row_index} <- Enum.zip(parsed_input, 0..(size - 1)),
          {element, element_index} <- Enum.zip(row, 0..(size - 1)),
          into: %{} do
        {"#{element_index}-#{row_index}", element}
      end

    {data, for(y <- 0..(size - 1), x <- 0..(size - 1), do: {x, y})}
  end
end
