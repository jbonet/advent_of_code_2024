defmodule AdventOfCode2024.Days.Day07Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day07

  describe("Day 7") do
    setup do
      %{input: Day07.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day07.part1(input) == 3749
    end

    test "part 2", %{input: input} do
      assert Day07.part2(input) == 11387
    end
  end
end
