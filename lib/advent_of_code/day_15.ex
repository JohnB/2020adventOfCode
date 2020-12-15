defmodule AdventOfCode.Day15 do
  import AdventOfCode

  def part1(args) do
    input =
      as_single_lines(args)
      |> List.first()
      |> String.split(",", trim: true)
      |> Enum.map(fn(str) ->
        String.to_integer(str)
        |> IO.inspect
      end)

#    input = [1,3,2] # 1
#    input = [2,1,3] # 10
#    input = [1,2,3] # 27
#    input = [2,3,1] # 78
#    input = [3,2,1] # 438
#    input = [3,1,2] # 1836

    # Say the input - ASSUME NO DUPES
    sayings =
      input
      |> Enum.with_index
      |> Enum.reduce(%{}, fn({num, index}, map) ->
        map
        |> Map.put(num, {index + 1})
        |> Map.put(:last_said, num)
      end)

    # then iterate thru the rules
#    end_at = 10
    end_at = 2021

    after_input = Enum.count(input) + 1
    said = Enum.reduce(after_input..end_at, sayings, fn(index, map) ->
      last_said = map[:last_said]
      last_age = map[last_said]
      last_zero = map[0]

      IO.puts(last_said)
      ((end_at - index) < 3) && IO.inspect(map, label: "index #{index} (#{last_said}) ")

      map
#      |> IO.inspect(label: "#{index}: #{last_said}\nvv")
      |> say(index, last_said, last_age, last_zero)
#      |> IO.inspect(label: "^^")
    end)

    IO.inspect(said)
    said[:last_said]
  end

  ### say

#  def say(map, index, last_said, nil, {last_zero}) do
#    IO.inspect([index, last_said, nil, last_zero, map], label: "56")
#    map
#    |> Map.put(last_said, {index, last_zero})
#    |> Map.put(:last_said, 0)
#  end

#  def say(map, index, last_said, nil, {last_zero, _}) do
#    IO.inspect([index, last_said, nil, last_zero, map], label: "63")
#    map
#    |> Map.put(last_said, {index, last_zero})
#    |> Map.put(:last_said, 0)
#  end

  def say(map, index, last_said, {age2, age1}, last_zero) do
#    IO.inspect([index, last_said, {age2, age1}, last_zero, map], label: "70")
    delta = age2 - age1
    last_delta = map[delta]

    case last_delta do
      nil -> Map.put(map, delta, {index})
      {age} -> Map.put(map, delta, {index, age})
      {age, _} -> Map.put(map, delta, {index, age})
    end
    |> Map.put(:last_said, delta)
    #    |> IO.inspect()
  end

  def say(map, index, last_said, {age}, {last_zero}) do
#    IO.inspect([index, last_said, {age}, last_zero, map], label: "84")
    map
    |> Map.put(last_said, {index, age})
    |> Map.put(0, {index, last_zero})
    |> Map.put(:last_said, 0)
  end

  def say(map, index, last_said, {age}, {last_zero, _}) do
#    IO.inspect([index, last_said, {age}, last_zero, map], label: "92")
    map
    |> Map.put(last_said, {index, age})
    |> Map.put(0, {index, last_zero})
    |> Map.put(:last_said, 0)
  end

#  def say(map, index, last_said, {age}, nil) do
#    IO.inspect([index, last_said, {age}, nil, map], label: "99")
#    map
#    |> Map.put(last_said, {index, age})
#    |> Map.put(0, {index})
#    |> Map.put(:last_said, 0)
#  end

  ### part 2 ######

  def part2(args) do
    result = as_single_lines(args)
  end
end
