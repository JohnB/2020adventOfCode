defmodule AdventOfCode.Day23 do
  import AdventOfCode

  def part1(args) do
    cups = parse_input(args)

    result =
      (1..100)
      |> Enum.reduce(cups, fn(turn_num, acc) ->
        current = List.first(acc)
        moving = Enum.slice(acc, 1..3)
        rest = Enum.slice(acc, 4..-1)
        move_cups(current, moving, rest)
        |> IO.inspect()
      end)
    one_index = Enum.find_index(result, fn(cup) -> cup == 1 end)
    array = Enum.slice(result, (one_index + 1)..-1) ++
      Enum.slice(result, 0..(one_index - 1))

    Enum.join(array)
  end

  def parse_input(args) do
    as_single_lines(args)
    |> List.first()
    |> String.split("", trim: true)
    |> Enum.map(fn(str) -> String.to_integer(str) end)
    |> IO.inspect()
  end

  def move_cups(current, moving, rest) do
    destination_index = find_destination(current, rest)
    Enum.slice(rest, 0..destination_index)
      ++ moving
      ++ Enum.slice(rest, (destination_index + 1)..-1)
      ++ [current]
  end

  def find_destination(0, rest) do
    find_destination(10, rest)
  end

  def find_destination(current, rest) do
    index = Enum.find_index(rest, fn(cup) -> cup == current - 1 end)
    case index do
      nil -> find_destination(current - 1, rest)
      _ -> index
    end
  end

  def part2(args) do
    cups = parse_input(args) ++ Enum.map(10..1_000_000, fn(n) -> n end)
    IO.inspect([Enum.slice(cups, 0..20), Enum.count(cups)])

    result =
      #(1..10)
      (1..10_000_000)
      |> Enum.reduce(cups, fn(turn_num, acc) ->
        current = List.first(acc)
        moving = Enum.slice(acc, 1..3)
        rest = Enum.slice(acc, 4..-1)
        move_cups(current, moving, rest)
      end)
    one_index = Enum.find_index(result, fn(cup) -> cup == 1 end)
    IO.inspect(one_index, label: "one_index")
    next_two = Enum.slice(result, (one_index + 1)..(one_index + 2))
    first_two = Enum.slice(result, 0..1)
    IO.inspect([next_two, first_two])

    List.first(next_two) * List.last(next_two)
  end
end
