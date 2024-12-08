defmodule AdventOfCode2024.Days.Day08 do
  use AdventOfCode2024.Puzzle

  def part1(grid) do
    antinodes = grid
    |> Enum.reduce(%{}, fn
      {_coords, "."}, acc ->
        acc

      {coords, antenna}, acc ->
        Map.update(acc, antenna, [coords], fn x -> [coords | x] end)
    end)
    |> Enum.flat_map(fn {antenna, locations} ->
        for location1 <- locations, location2 <- locations, location1 != location2, do: {antenna, to_point(location1), to_point(location2)}
    end)
    |> Enum.reduce([], fn {antenna, p1, p2} = x, acc ->
      if {antenna, p2, p1} in acc, do: acc, else: [x | acc]
    end)
    |> IO.inspect(label: "Pairs")
    |> Enum.reduce([], fn {antenna, {x1, y1} = p1, {x2, y2} = p2}, acc ->
      {vx, vy} = v = {abs(x1 - x2), abs(y1 - y2)}

      antinodes =
        cond do
          x1 < x2 and y1 < y2 -> [{x1 + -1 * vx, y1 + -1 * vy}, {x2 + vx, y2 + vy}]
          x1 < x2 and y1 > y2 -> [{x1 + -1 * vx, y1 + vy}, {x2 + vx, y2 + -1 * vy}]
          x1 > x2 and y1 < y2 -> [{x1 + vx, y1 + vy}, {x2 + -1 * vx, y2 + -1 * vy}]
          x1 > x2 and y1 > y2 -> [{x1 + vx, y1 + vy}, {x2 - 1 * vx, y2 - 1* vy}]
        end
      IO.puts("Pair of antennas #{antenna}: #{inspect(p1)} - #{inspect(p2)} (vector: #{inspect(v)}) generates antinodes: #{inspect(antinodes)}")

      acc ++ (antinodes)
    end)
    |> IO.inspect(label: "Possible antinodes")
    |> Enum.reduce([], fn antinode, acc ->
      if valid_antinode?(grid, antinode) do
        [antinode | acc]
      else
        acc
      end
    end)
    |> IO.inspect(label: "Valid antinodes")


    Enum.reduce(antinodes, grid, fn antinode, grid ->
      nil
    end)


    Enum.count(antinodes)
  end

  def part2(_input) do
    0
  end

  def valid_antinode?(grid, {x, y} = antinode) do
    current_value = Map.get(grid, "#{x}-#{y}", nil) |> IO.inspect(label: "Checking for antinode #{inspect(antinode)}")

    current_value != nil
  end

  def check_sign({x, y}) when x < 0 or y < 0, do: :neg
  def check_sign(_), do: :pos

  defp to_point(point_str), do: point_str |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

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
