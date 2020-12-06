defmodule Mix.Tasks.D20.P2 do
  use Mix.Task

  import AdventOfCode.Day20

  @shortdoc "Day 20 Part 2"
  def run(args) do
    #input = File.read!('lib/mix/tasks/d20.example.txt')
    input = File.read!('lib/mix/tasks/d20.input.txt')

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
