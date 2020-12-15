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

    {first_bus, _} = List.first(buses)
                     |> IO.inspect

    # example
      #    [{7, 0}, {13, 1}, {59, 4}, {31, 6}, {19, 7}]
      #
      #     Enum.sort
      #   [{7, 0}, {13, 1}, {19, 7}, {31, 6}, {59, 4}]
      # I was able to brute-force this answer by uncommenting:
      # find_result(first_bus, buses, 0)
      # find_result(first_bus, buses, 0)

    # real input result at this point is this table of primes and
    # remainders
    # https://brilliant.org/wiki/chinese-remainder-theorem/
    #
    #  {643, 19}    643j + 19 = 50 mod 509
    #                 j == 80 (mod 509)  [or so Wolfram alpha says]
    #  {509, 50},   643(509k + 50) + 19 = 9 mod 41
    #                 k = 1  (mod 37)
    #               643(509(41l + 9) + 50) + 19 = 56 mod 37
    #                 l = 31 (mod 37)
    #  {41, 9},     643(509(41(37m + 56) + 9) + 50) + 19 = 79 mod 29
    #                 m = 1
    #  {37, 56},    643(509(41(37(29n + 79) + 56) + 9) + 50) + 19 = 42 mod 23
    #                 n = 16
    #  {29, 79},    643(509(41(37(29(23o + 42) + 79) + 56) + 9) + 50) + 19 = 0 mod 19
    #                 o = 17
    #  {23, 42},    643(509(41(37(29(23(19p + 0) + 42) + 79) + 56) + 9) + 50) + 19 = 36 mod 17
    #                 p = 7
    #  {19, 0},     643(509(41(37(29(23(19(17q + 36) + 0) + 42) + 79) + 56) + 9) + 50) + 19 = 37 mod 13
    #  {17, 36},      q = 5
    #  {13, 37},    761985572711374 (too high)
    # supposedly higher than:
    #               100000000000000
    #               1390548191579807
    #               106965245506139
    # https://www.geeksforgeeks.org/chinese-remainder-theorem-set-2-implementation/


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


#    find_result(first_bus, buses, 0)
#    find_result(first_bus, buses, 1730426330)
    find_result(first_bus, buses, 100040434744591)
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