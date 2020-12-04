defmodule AdventOfCode.Day02 do
  def valid_line?(line) do
    [range, char, password] = String.split(line, " ")
    [low, high] = String.split(range, "-")
    char = String.slice(char, 0, 1)
#    IO.puts("Are there #{low} to #{high} letter '#{char}' in '#{password}'?")
    {:ok, regex} = Regex.compile(char)
    matches = Regex.scan(regex, password) |> Enum.count()
    low = String.to_integer(low)
    high = String.to_integer(high)
#    IO.inspect([matches, low, high, regex])

    (low <= matches && high >= matches)
  end

  def part1(string) do
    string
    |> String.trim
    |> String.split("\n")
    |> Enum.reduce(0, fn(line, acc) ->
      case valid_line?(line) do
        true -> acc + 1
        _ -> acc
      end
    end)
  end

  def part2(_args) do
  end
end
