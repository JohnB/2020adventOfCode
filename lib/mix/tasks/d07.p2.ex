defmodule Mix.Tasks.D07.P2 do
  use Mix.Task

  import AdventOfCode.Day07

  @shortdoc "Day 07 Part 2"
  def run(args) do
#    input = "
#shiny gold bags contain 2 dark red bags.
#dark red bags contain 2 dark orange bags.
#dark orange bags contain 2 dark yellow bags.
#dark yellow bags contain 2 dark green bags.
#dark green bags contain 2 dark blue bags.
#dark blue bags contain 2 dark violet bags.
#dark violet bags contain no other bags.
#"
    input = File.read!('lib/mix/tasks/d07.input.txt')

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
