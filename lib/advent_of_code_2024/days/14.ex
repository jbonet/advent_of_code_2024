defmodule AdventOfCode2024.Days.Day14 do
  use AdventOfCode2024.Puzzle

  def get_size() do
    if Application.get_env(:advent_of_code_2024, :sample_data) do
      {11, 7}
    else
      IO.puts("Using real data")
      {101, 103}
    end
  end

  def part1(input) do
    size = get_size()

    input
    |> simulate(size)
    |> Enum.map(fn %{point: point} -> point end)
    |> build_quadrants(size)
    |> Stream.map(fn {_, v} -> length(v) end)
    |> Enum.product()
  end

  def part2(input) do

  end

  def simulate(input, size) do
    move(input, size, 100)
  end

  defp move(input, size, rounds \\ 1)
  defp move(input, _size, 0), do: input
  defp move(input, size, rounds) do
#    IO.puts("Move (Remaining: #{rounds})")
    new_input =
      do_move(input, size)
#      |> IO.inspect(label: "after_moving")

    move(new_input, size, rounds - 1)
  end

  defp do_move(robots, size, result \\ [])
  defp do_move([], _size, result), do: result
  defp do_move([%{point: {x, y} = point, vector: {vx, vy}} = robot | rest], {width, height} = size, moved) do
    get_new_position = fn
      x, mod when x < 0 -> mod + x
      x, mod -> rem(x, mod)
    end
    new_location = {get_new_position.(x + vx, width), get_new_position.(y + vy, height)}

#    IO.puts("Move #{inspect(point)} to: #{inspect(new_location)}")

    do_move(rest, size, [%{robot | point: new_location} | moved])
  end

  defp build_grid(current_positions, {width, height}) do
    empty_grid = for x <- 0..width - 1, y <- 0..height - 1, into: %{}, do: {{x,y}, MapSet.new()}

    Enum.reduce(current_positions, empty_grid, fn %{point: {x, y}, vector: vector}, grid ->
      Map.update(grid, {x, y}, MapSet.new([vector]), fn cell -> MapSet.put(cell, vector) end)
    end)
  end

  defp print_grid(grid, {width, height}) do
    for y <- 0..height - 1 do
      for x <- 0..width - 1 do
        IO.write(MapSet.size(grid[{x, y}]))
      end
      IO.puts("")
    end
  end

  defp build_quadrants(locations, {width, height}) do
    middle_x = (width - 1) / 2
    middle_y = (height - 1) / 2

    Enum.reduce(locations, %{first: [], second: [], third: [], fourth: []}, fn
      {x, y} = point, acc when x < floor(middle_x) and y < floor(middle_y) -> Map.update(acc, :first, [point], fn first -> [point | first] end)
      {x, y} = point, acc when x > ceil(middle_x) and y < floor(middle_y) -> Map.update(acc, :second, [point], fn first -> [point | first] end)
      {x, y} = point, acc when x < floor(middle_x) and y > ceil(middle_y) -> Map.update(acc, :third, [point], fn first -> [point | first] end)
      {x, y} = point, acc when x > ceil(middle_x) and y > ceil(middle_y) -> Map.update(acc, :fourth, [point], fn first -> [point | first] end)
      x, acc -> acc
    end)
  end

  def parse_input(input) do
    to_point = fn x -> x |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1) |> List.to_tuple() end

    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " ", trim: true))
    |> Stream.map(&Enum.into(&1, %{}, fn
      "p=" <> point -> {:point, to_point.(point)}
      "v=" <> vector -> {:vector, to_point.(vector)}
    end)
    )
    |> Enum.to_list()
  end
end