defmodule AdventOfCode2024.Days.Day06 do
  use AdventOfCode2024.Puzzle

  @obstacles ["#", "O"]

  def part1(input) do
    {starting_point, _direction} =
      input
      |> Enum.find(fn {_, x} -> x not in ["#", "."] end)

    {:ok, visited} =
      move_guard(
        input,
        starting_point |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      )

    visited
    |> MapSet.to_list()
    |> Enum.map(fn {x, _} -> x end)
    |> MapSet.new()
    |> MapSet.size()
  end

  def part2(input) do
    {starting_point, direction} =
      input
      |> Enum.find(fn {_, x} -> x not in ["#", "."] end)

    starting_point =
      starting_point |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

    initial_position = {starting_point, direction}

    {:ok, visited} = move_guard(input, starting_point)

    visited
    |> MapSet.delete(initial_position)
    |> MapSet.to_list()
    |> Enum.map(fn {x, _} -> x end)
    |> MapSet.new()
    |> MapSet.to_list()
    |> Task.async_stream(
      fn x -> input |> put_in_location(x, "O") |> move_guard(starting_point) end,
      max_concurrency: 20
    )
    |> Stream.reject(fn {_, {res, _}} -> res == :ok end)
    |> Enum.count()
  end

  defp move_guard(grid, location, visited \\ MapSet.new())

  defp move_guard(grid, current_location, visited) do
    # Update visited to add current point
    visited = MapSet.put(visited, {current_location, get_location(grid, current_location)})

    # Calculate next location
    with {{next_location, next_direction}, false} <- get_next(grid, current_location, visited) do
      # Update guard position
      grid
      |> put_in_location(current_location, ".")
      |> put_in_location(next_location, next_direction)
      |> move_guard(next_location, visited)
    else
      {_, true} ->
        {:error, :loop}

      _ ->
        # Next position outside the grid, stop
        {:ok, visited}
    end
  end

  defp get_next(grid, {x, y} = current_location, visited) do
    current_direction = get_location(grid, current_location)

    with {vx, vy} <- get_vector(current_direction),
         next_location <- {x + vx, y + vy},
         value <- get_location(grid, next_location) do
      case value do
        value when value in @obstacles ->
          grid
          |> rotate_guard(current_location, current_direction)
          |> get_next(current_location, visited)

        "." ->
          result = {next_location, get_location(grid, current_location)}
          {result, MapSet.member?(visited, result)}

        _ ->
          nil
      end
    end
  end

  defp get_vector("^"), do: {0, -1}
  defp get_vector(">"), do: {1, 0}
  defp get_vector("<"), do: {-1, 0}
  defp get_vector("v"), do: {0, 1}
  defp get_vector(_), do: nil

  defp rotate_guard(grid, location, direction) do
    put_in_location(grid, location, get_rotated_direction(direction))
  end

  defp get_rotated_direction("^"), do: ">"
  defp get_rotated_direction(">"), do: "v"
  defp get_rotated_direction("<"), do: "^"
  defp get_rotated_direction("v"), do: "<"

  defp get_location(grid, {x, y}), do: Map.get(grid, "#{x}-#{y}", nil)
  defp put_in_location(grid, {x, y}, value), do: Map.put(grid, "#{x}-#{y}", value)

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
