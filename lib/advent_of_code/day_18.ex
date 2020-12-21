defmodule AdventOfCode.Day18 do
  import AdventOfCode

  # Cribbed from https://stackoverflow.com/questions/14952113/how-can-i-match-nested-brackets-using-regex
  @paren_matcher ~r/(\(([^()]|(?R))*\))/

  # Solution: 14208061823964
  def part1(args) do
    IO.puts("Expected example output: 71, 51, 26, 437, 12240, 13632")
    _result =
      as_single_lines(args)
      |> Enum.map(fn(line) ->
        IO.puts("----")
        line
        |> String.replace(~r/\s+/, "")
        |> IO.inspect()
        |> recurse_until_solved()
        |> String.to_integer()
      end)
      |> IO.inspect(label: "done?")
      |> Enum.sum
  end

  def recurse_until_solved(line) do
    case Regex.match?( ~r/\(/, line) do
      true -> solve_parens(line) |> solve_equation()
      _ -> solve_equation(line)
    end
  end

  def solve_parens(line) do
    Regex.replace(@paren_matcher, line, fn(full, match) ->
      recurse_until_solved(String.slice(full, 1..-2))
    end)
  end

  def solve_equation(line) do
    IO.inspect(line)
    {num1, rest} = Integer.parse(line)
    op = String.slice(rest, 0, 1)
    {num2, rest2} = (op == "") && {nil, nil} || Integer.parse(String.slice(rest, 1..-1))
    case op do
      "+" -> solve_equation("#{num1 + num2}#{rest2}")
      "*" -> solve_equation("#{num1 * num2}#{rest2}")
      "" -> "#{num1}"
    end
  end

  ####################

  def part2(args) do
    IO.puts("Expected example output: 231, 51, 46, 1445, 669060, 23340")
    _result =
      as_single_lines(args)
      |> Enum.map(fn(line) ->
        IO.puts("----")
        line
        |> String.replace(~r/\s+/, "")
        |> IO.inspect()
        |> recurse_until_solved2()
        |> String.to_integer()
      end)
      |> IO.inspect(label: "done?")
      |> Enum.sum
  end

  def recurse_until_solved2(line) do
    case Regex.match?( ~r/\(/, line) do
      true -> solve_parens2(line) |> solve_equation2()
      _ -> solve_equation2(line)
    end
  end

  def solve_parens2(line) do
    Regex.replace(@paren_matcher, line, fn(full, match) ->
      recurse_until_solved2(String.slice(full, 1..-2))
    end)
  end

  def solve_equation2(line) do
    IO.inspect(line)
    Regex.match?(~r/\+/, line) &&
      Regex.replace(~r/(\d+)\+(\d+)/, line, fn(match) ->
        [x,y] = String.split(match, "+")
        x = String.to_integer(x)
        y = String.to_integer(y)
        "#{x+y}"
      end, global: false) |> solve_equation2() ||
      solve_equation(line)
  end
end
