defmodule AdventOfCode.Day05 do
  def extract_rows_and_columns(string) do
    string
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn(line) ->
      {row, _} =
        String.slice(line, 0, 7)
        |> String.replace("F", "0")
        |> String.replace("B", "1")
        |> Integer.parse(2)
      {column, _} =
        String.slice(line, 7, 3)
        |> String.replace("L", "0")
        |> String.replace("R", "1")
        |> Integer.parse(2)
      seatID = 8 * row + column

      [line, row, column, seatID]
    end)
  end

  def part1(args) do
    extract_rows_and_columns(args)
    |> Enum.map(fn([line, row, column, seatID]) -> seatID end)
    |> Enum.sort()
    |> List.last()
  end

  def part2(args) do
    found_boarding_passes =
      extract_rows_and_columns(args)
      |> Enum.map(fn([line, row, column, seatID]) -> seatID end)
      |> Enum.sort()

    earliest = List.first(found_boarding_passes)
    {next_seat, index} =
      found_boarding_passes
      |> Enum.with_index
      |> Enum.find(fn({x, i}) -> x != earliest + i end)

    next_seat - 1
  end
end
