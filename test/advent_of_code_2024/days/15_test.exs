defmodule AdventOfCode2024.Days.Day15Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day15

  describe("Day 15") do
    setup do
      %{input: Day15.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day15.part1(input) == 10092
    end

    test "part 2", %{input: input} do
      assert Day15.part2(input) == 9021
    end
  end
end
