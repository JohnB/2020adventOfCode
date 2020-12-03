defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @tag :skip
  test "part1" do
    input = [1721,
             979,
             366,
             299,
             675,
             1456]
    result = part1(input)

    assert result == [299, 1721]
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
