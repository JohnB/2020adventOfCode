defmodule AdventOfCode.Day18 do
  import AdventOfCode

  # Cribbed from https://stackoverflow.com/questions/14952113/how-can-i-match-nested-brackets-using-regex
  @paren_matcher ~r/(\(([^()]|(?R))*\))/

  def part1(args) do
    IO.puts("Expected example output: 71, 51, 26, 437, 12240, 13632")
    _result =
      as_single_lines(args)
      |> Enum.map(fn(line) ->
        IO.puts("----")
        line
        |> solve1line()
      end)
      |> IO.inspect(label: "done?")
#      |> calculate()
#      |> Enum.sum
  end

  def solve1line(line) do
    line
    |> String.replace(~r/\s+/, "")
    |> IO.inspect()
    |> evaluate()
  end

  def evaluate(line) do
    IO.inspect(line, label: "evaluate")
    case Regex.match?(~r/^\d+$/, line) do
      true -> String.to_integer(line)
      _ -> solve(line)
    end
  end

  def solve(line) do
    case Regex.match?(~r/^\d+(\+|\*)\d+/, line) do
      true -> calculate(line)
      _ -> Regex.replace(@paren_matcher, line, fn(full, match) -> solve1line(String.slice(full, 1..-2)) end)
    end
#    |> solve()
  end

  def calculate(match) do
    {num1, rest} = Integer.parse(match)
    IO.inspect({num1, rest}, label: "calculate")
    "#{calc(num1, rest)}"
    |> IO.inspect(label: "end Calculate")
  end

  def calc(num1, "*" <> num2) do
    {num2, rest} = Integer.parse(num2)
    calc(num1 * num2, rest)
  end
  def calc(num1, "+" <> num2) do
    {num2, rest} = Integer.parse(num2)
    calc(num1 + num2, rest)
  end
  def calc(num, "") do
    num
  end
  def calc(num) do
    num
  end

  def part2(args) do
    result = as_single_lines(args)
  end
end
