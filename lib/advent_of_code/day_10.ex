defmodule AdventOfCode.Day10 do
  import AdventOfCode

  def part1(args) do
    sorted_adapters =
      as_single_lines(args)
      |> Enum.map(fn(str) -> String.to_integer(str) end)
      |> Enum.sort

#    first_val = List.first(sorted_adapters)
    result =
      sorted_adapters
      |> Enum.reduce(%{ones: 0, threes: 0, prev: 0}, fn(x, acc = %{ones: ones, threes: threes, prev: prev}) ->
        IO.inspect([x, acc])
        case x - prev do
          1 -> %{acc | ones: ones + 1, prev: x}
          3 -> %{acc | threes: threes + 1, prev: x}
#          _ -> %{acc | threes: threes + 3, prev: x}
        end
      end)
    IO.inspect(result, label: "result")

      result.ones * (result.threes + 1)
  end

  def part2(args) do
    deltas =
      as_single_lines(args)
      |> Enum.map(fn(str) -> String.to_integer(str) end)
      |> Enum.sort
      |> IO.inspect
      |> Enum.chunk_every(2, 1)
      |> Enum.map(fn([a | b]) -> (List.first(b) || (a+3)) - a end)
      |> IO.inspect

    str = "1" <> Enum.join(deltas, "") <> "3"
    strZ = String.replace(str, "1111", "Z")
    str2 = String.replace(strZ, "111", "X")
    str3 = String.replace(str2, "11", "Y")
    zzz = (String.split(str3, "Z") |> Enum.count()) - 1
    fourX = (String.split(str3, "X") |> Enum.count()) - 1
    twoY = (String.split(str3, "Y") |> Enum.count()) - 1
    IO.inspect([str, zzz, fourX, twoY, str3])

    case {zzz, fourX, twoY} do
      {0, _,  _} -> :math.pow(4, fourX) * :math.pow(2, twoY)
      {_, _,  _} -> :math.pow(4, fourX) * :math.pow(2, twoY) * :math.pow(7, zzz)
    end

  end
end

#11 = 2
#111 = 4
#1111 = 16?

"
3113
323

31113
3123
3213
333

311113
31123
31213
3133
32113
3223
3313

"