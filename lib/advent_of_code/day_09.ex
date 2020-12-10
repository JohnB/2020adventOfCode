defmodule AdventOfCode.Day09 do
  import AdventOfCode

  # return true if some of the previous N numbers add to the target
  def sum_from_last_set(numbers, start, window, target) do
    subset = Enum.slice(numbers, start, window)
    Enum.find(subset, fn(n) ->
      looking_for = target - n
      case {looking_for == n, Enum.member?(subset, looking_for)} do
        {true, _} -> false
        {false, true} -> true
        _ -> false
                            end
    end)
  end

  def part1(args, example) do
    window = example && 5 || 25
    numbers =
      as_single_lines(args)
      |> Enum.map(fn(line) -> String.to_integer(line) end)

    result = Enum.find(window..Enum.count(numbers), fn(n) ->
      !sum_from_last_set(numbers, n - window, window, Enum.at(numbers, n))
    end)
    Enum.at(numbers, result)
  end

  def part2(args, example) do
    IO.puts("solution is very inefficient and takes about 2 minutes")
    window = example && 5 || 25
    numbers =
      as_single_lines(args)
      |> Enum.map(fn(line) -> String.to_integer(line) end)

    position_of_bad_number = Enum.find(window..Enum.count(numbers), fn(n) ->
      !sum_from_last_set(numbers, n - window, window, Enum.at(numbers, n))
    end)
    bad_number = Enum.at(numbers, position_of_bad_number)
    IO.puts("bad number #{bad_number} is at #{position_of_bad_number}")
    IO.inspect(Enum.slice(numbers, 500, 20), label: "solution range")

    start_of_subset = Enum.find(0..(position_of_bad_number - 1), fn(start) ->
      # This is an N^2 solution that would be much better if we stopped summing as
      # soon as we exceed the bad_number.
      #
      finish_position = Enum.find((start + 1)..(position_of_bad_number - 1), fn(finish) ->
        sum = Enum.reduce(start..finish, 0, fn(position, acc) ->
          acc + Enum.at(numbers, position)
        end)
#        IO.inspect([sum, bad_number], label: "sums")
        sum == bad_number
      end)

      case finish_position do
        nil -> false
        _ ->
          final_set = Enum.slice(numbers, start..finish_position) |> Enum.sort
          start_num = List.first(final_set)
          IO.inspect([finish_position])
          finish_num = List.last(final_set)
          result = start_num + finish_num
          IO.puts("Solution: #{start}(#{start_num}) to #{finish_position}(#{finish_num}) = #{result}")
          true
      end
    end)
  end
end

#30684790 +  31929175 +  33239826 +  37982233 +  32111531 +  35048416 + 34484211 +  34933587 +  53564537 +  35733886 +  53833200 +  37317716 +  62711937 +  51019481 +  51993598 + 52688226 + 61755566
# sorted, it becomes
# [30684790, 31929175, 32111531, 33239826, 34484211, 34933587, 35048416, 35733886,
# 37317716, 37982233, 51019481, 51993598, 52688226, 53564537, 53833200, 61755566,
# 62711937]
# and thus 30684790 + 62711937 == 93396727 is the answer
