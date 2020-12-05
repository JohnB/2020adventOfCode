defmodule Mix.Tasks.D04.P1 do
  use Mix.Task

  import AdventOfCode.Day04

  @shortdoc "Day 04 Part 1"
  def run(args) do
#    input = File.read!('/Users/johnb/dev/2020adventOfCode/lib/mix/tasks/d04.example.txt')
    input = File.read!('/Users/johnb/dev/2020adventOfCode/lib/mix/tasks/d04.input.txt')

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
