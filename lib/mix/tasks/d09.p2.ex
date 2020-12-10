defmodule Mix.Tasks.D09.P2 do
  use Mix.Task

  import AdventOfCode
  import AdventOfCode.Day09

  @shortdoc "Day 09 Part 2"
  def run(args) do
    example = Enum.member?(args, "-e")
    input = get_input("09", args)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2(example) end}),
      else:
        input
        |> part2(example)
        |> IO.inspect(label: "Part 2 Results")
  end
end
