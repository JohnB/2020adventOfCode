defmodule AdventOfCode.Day01 do
  def match_target?(target, whole_list) do
    result =
      whole_list
      |> Enum.find(fn(number) -> Enum.member?(whole_list, target - number) end)

    result
  end

  def part1(args) do
    first_number = match_target?(2020, args)
    second_number = 2020 - first_number
    result = first_number * second_number
    IO.puts("#{first_number} + #{second_number} == #{result}")

    result
  end

  def get_three_numbers(first_number, args) do
    target = 2020 - first_number
    second_number = match_target?(target, args)
    case second_number do
      nil -> []
      x -> [first_number, second_number, 2020 - first_number - second_number]
    end
  end

  def part2(args) do
    [a, b, c] = Enum.reduce(args, [], fn(number, acc) ->
      all_three = get_three_numbers(number, args)
      case {acc, all_three} do
        {[], []} -> []
        {[], [aa, bb, cc]} -> [aa, bb, cc]
        {x, _y} -> x
      end
    end)
    IO.inspect("#{a} + #{b} + #{c}")

    a * b * c
  end
end
