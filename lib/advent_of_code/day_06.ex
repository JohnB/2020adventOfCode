defmodule AdventOfCode.Day06 do
  def part1(args) do
    args
    |> String.trim
    |> String.split("\n\n")
    |> Enum.reduce(0, fn(chunk, acc) ->
      count =
        String.replace(chunk, ~r/\s+/, "")
        |> String.trim
        |> String.split("")
        |> Enum.uniq()
        |> Enum.count()
      acc + count - 1
    end)
  end

  def part2(args) do
    args
    |> String.trim
    |> String.split("\n\n")
    |> Enum.reduce(0, fn(chunk, acc) ->
      size =
        chunk
        |> String.split("\n")
        |> Enum.reduce(nil, fn(line, set) ->
          inner_set =
            line
            |> String.split("")
            |> Enum.uniq()
            |> MapSet.new()

            case set do
              nil -> inner_set
              _ -> MapSet.intersection(set, inner_set)
            end
        end)
        |> MapSet.size

      acc + size - 1 # subtract 1 to ignore the empty string
    end)
  end
end
