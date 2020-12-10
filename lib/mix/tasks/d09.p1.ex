defmodule Mix.Tasks.D09.P1 do
  use Mix.Task

  import AdventOfCode
  import AdventOfCode.Day09

  @shortdoc "Day 09 Part 1"
  def run(args) do
    example = Enum.member?(args, "-e")
    input = get_input("09", args)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1(example) end}),
      else:
        input
        |> part1(example)
        |> IO.inspect(label: "Part 1 Results")
  end
end
