defmodule AdventOfCode.Day13 do
  import AdventOfCode

  def part1(args) do
    result = as_single_lines(args)
    earliest = List.first(result) |> String.to_integer
               |> IO.inspect
    buses =
      List.last(result)
      |> String.split(",")
      |> Enum.filter(fn(value) -> value != "x" end)
      |> Enum.map(fn(value) -> String.to_integer(value) end)
      |> IO.inspect

    # What multiple of bus number is the least past "earliest"?
    multiples = Enum.map(buses, fn(bus) -> {bus, (Float.floor(earliest / bus) + 1) * bus} end)
                |> IO.inspect

    {bus, arrival} =
          Enum.sort_by(multiples, fn({bus, arrival}) -> arrival end )
                                                        |> List.first
                                                        |> IO.inspect

    bus * (arrival - earliest)
  end

  def part2(args) do
    result = as_single_lines(args)
    #    earliest = List.first(result) |> String.to_integer

    buses =
      List.last(result)
      |> String.split(",")
      |> Enum.with_index
      #|> IO.inspect
      |> Enum.map(fn({bus, index}) ->
        case bus do
          "x" -> {nil, nil}
          _ -> {String.to_integer(bus), index}
        end
      end)
      |> Enum.filter(fn({bus, index}) -> bus != nil end)
      |> Enum.sort_by(fn({bus, arrival}) -> arrival end )
      |> IO.inspect

      # example
      #    [{7, 0}, {13, 1}, {59, 4}, {31, 6}, {19, 7}]
      #
      #     Enum.sort
      #   [{7, 0}, {13, 1}, {19, 7}, {31, 6}, {59, 4}]

# real input
#      by_arrival =
#      [
#        {19, 0},
#        {41, 9},
#        {643, 19}, #
#        {17, 36},  # 4 x 9
#        {13, 37},
#        {23, 42},  # 2 * 3 * 7
#        {509, 50},
#        {37, 56},
#        {29, 79}
#      ]
      start = 19 * (643 - 1)
      increments = 643


    #    foo = [
#    foo = [
    #  {13, 37},
    #  {17, 36},
    #  {19, 0},
    #  {23, 42},
    #  {29, 79},
    #  {37, 56},
    #  {41, 9},
    #  {509, 50},
    #  {643, 19}
    # all the buses are prime, so the time between timestamps is
    # the product of them all
    # and the distance "back" to t is
    # each of the arrival offsets by all the *other* primes
    #]
#      {19, 0},
#      {41, 9},
#      {643, 19},
#      {17, 36},
#      {13, 37},
#      {23, 42},
#      {509, 50},
#      {37, 56},
#      {29, 79}
#    ]


    {first_bus, _} = List.first(buses)
                     |> IO.inspect
#    find_result(first_bus, buses, 1730426330)
    #find_result(first_bus, buses, 99999999999984)
  end


  def is_multiple?(big, small) do
    multiple = big / small
    {x, y} = Float.ratio(multiple)
    y == 1
  end

  def find_result(first_bus, buses, start) do
    IO.puts(start)
    success = Enum.all?(buses, fn({bus, offset}) ->
      is_multiple?(start + offset, bus)
    end)
    case success do
      true -> start
      _ -> find_result(first_bus, buses, start + first_bus)
    end
  end
end

"""
[
  {19, 0},
  {41, 9},
  {643, 19}, # allows us to multiply?
  {17, 36},
  {13, 37},
  {23, 42},
  {509, 50},
  {37, 56},
  {29, 79}
]

"""