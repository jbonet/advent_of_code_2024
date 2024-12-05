defmodule AdventOfCode2024.Days.Day05Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day05

  describe("Day 5") do
    setup do
      %{input: Day05.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day05.part1(input) == 143
    end

    test "part 2", %{input: input} do
      assert Day05.part2(input) == 123
    end
  end
end
