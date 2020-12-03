defmodule AdventOfCode.Day01 do
  Target 2020

  def part1(args) do
    first_number =
        args
        |> Enum.find(fn(number) -> Enum.member?(args, Target - number) end)

    [first_number, Target - first_number]
  end

  def part2(args) do
  end
end
