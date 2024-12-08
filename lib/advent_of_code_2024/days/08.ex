defmodule AdventOfCode2024.Days.Day08 do
  use AdventOfCode2024.Puzzle

  def part1(grid) do
    grid
    |> Enum.reduce(%{}, fn
      {_coords, "."}, acc ->
        acc

      {coords, antenna}, acc ->
        Map.update(acc, antenna, [coords], fn x -> [coords | x] end)
    end)
    |> Stream.flat_map(fn {antenna, locations} ->
      for location1 <- locations,
          location2 <- locations,
          location1 != location2,
          do: {antenna, to_point(location1), to_point(location2)}
    end)
    |> Enum.reduce([], fn {_antenna, {x1, y1}, {x2, y2}}, acc ->
      {vx, vy} = v = {abs(x1 - x2), abs(y1 - y2)}

      antinodes =
        cond do
          x1 < x2 and y1 < y2 -> [{x1 + -1 * vx, y1 + -1 * vy}, {x2 + vx, y2 + vy}]
          x1 > x2 and y1 > y2 -> [{x1 + vx, y1 + vy}, {x2 - 1 * vx, y2 - 1 * vy}]
          x1 < x2 and y1 > y2 -> [{x1 + -1 * vx, y1 + vy}, {x2 + vx, y2 + -1 * vy}]
          x1 > x2 and y1 < y2 -> [{x1 + vx, y1 + -1 * vy}, {x2 + -1 * vx, y2 + vy}]
        end

      acc ++ antinodes
    end)
    |> Enum.reduce([], fn {x, y}, acc ->
      if Map.get(grid, "#{x}-#{y}", nil) != nil, do: [{x, y} | acc], else: acc
    end)
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.count()
  end

  def part2(_input) do
    0
  end

  defp to_point(point_str),
    do: point_str |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

  def parse_input(input) do
    parsed_input =
      input
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Enum.to_list()

    for {row, row_index} <-
          Enum.with_index(parsed_input, fn element, index -> {element, index} end),
        {element, element_index} <-
          Enum.with_index(row, fn element, index -> {element, index} end),
        into: %{} do
      {"#{element_index}-#{row_index}", element}
    end
  end
end
