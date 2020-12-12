defmodule Mix.Tasks.D21.P2 do
  use Mix.Task

  import AdventOfCode
  import AdventOfCode.Day21

  @shortdoc "Day 21 Part 2"
  def run(args) do
    input = get_input("21", args)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
