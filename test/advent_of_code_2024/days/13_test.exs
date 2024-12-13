defmodule AdventOfCode2024.Days.Day13Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day13

  describe("Day 13") do
    setup do
      %{input: Day13.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day13.part1(input) == 480
    end

    test "part 2", %{input: input} do
      assert Day13.part2(input) == nil
    end
  end
end
