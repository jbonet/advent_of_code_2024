defmodule AdventOfCode2024.Days.Day10Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day10

  describe("Day 10") do
    setup do
      %{input: Day10.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day10.part1(input) == 36
    end

    test "part 2", %{input: input} do
      assert Day10.part2(input) == 81
    end
  end
end
