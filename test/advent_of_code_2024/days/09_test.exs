defmodule AdventOfCode2024.Days.Day09Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day09

  describe("Day 9") do
    setup do
      %{input: Day09.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day09.part1(input) == 1928
    end

    test "part 2", %{input: input} do
      assert Day09.part2(input) == nil
    end
  end
end
