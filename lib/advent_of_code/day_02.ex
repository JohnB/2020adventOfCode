defmodule AdventOfCode.Day02 do
  def parse_line(line) do
    [range, char, password] = String.split(line, " ")
    [low, high] = String.split(range, "-")
    char = String.slice(char, 0, 1)
    low = String.to_integer(low)
    high = String.to_integer(high)
    %{low: low, high: high, char: char, password: password}
  end

  def valid_p1_line?(line) do
    %{low: low, high: high, char: char, password: password} = parse_line(line)
    {:ok, regex} = Regex.compile(char)
    matches = Regex.scan(regex, password) |> Enum.count()

    (low <= matches && high >= matches)
  end

  def valid_p2_line?(line) do
    %{low: low, high: high, char: char, password: password} = parse_line(line)

    # the known-plaintext character must be found at either of two locations
    # but not at both. So if we keep a count of the number of matches
    # it should be 1 and only 1.
    count = (String.slice(password, low - 1, 1) == char) && 1 || 0
    count = (String.slice(password, high - 1, 1) == char) && count+1 || count

    count == 1
  end

  def part1(string) do
    string
    |> String.trim
    |> String.split("\n")
    |> Enum.reduce(0, fn(line, acc) ->
      case valid_p1_line?(line) do
        true -> acc + 1
        _ -> acc
      end
    end)
  end

  def part2(string) do
    string
    |> String.trim
    |> String.split("\n")
    |> Enum.reduce(0, fn(line, acc) ->
      case valid_p2_line?(line) do
        true -> acc + 1
        _ -> acc
      end
    end)
  end
end
