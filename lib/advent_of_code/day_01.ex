defmodule AdventOfCode.Day01 do
  def part1(args) do
    first_number =
        args
        |> Enum.find(fn(number) -> Enum.member?(args, 2020 - number) end)

    second_number = 2020 - first_number
    result = first_number * second_number
    IO.puts("#{first_number} + #{second_number} == #{result}")

    result
  end

  def part2(_args) do
  end
end
