defmodule AdventOfCode2024.Days.Day12Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day12

  describe("Day 12") do
    setup do
      %{input: Day12.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day12.part1(input) == 1930
    end

    test "part 2", %{input: input} do
      assert Day12.part2(input) == nil
    end
  end
end
