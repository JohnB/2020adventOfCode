defmodule AdventOfCode.Day19 do
  import AdventOfCode

  def part1(args) do
    [rules, message] = as_doublespaced_paragraphs(args)
    message = String.split(message, "\n", trim: true)
    ruleset =
      rules
      |> as_single_lines()
      |> Enum.reduce(%{}, fn(rule, acc) ->
        [rule_num, fields] =
          String.split(rule, ": ")
        options =
          fields
          |> String.split(" | ")
          |> Enum.map(fn(field) ->
            String.split(field, " ")
            |> Enum.map(fn(entry) -> int_or_string(entry) end)
          end)
        Map.put(acc, String.to_integer(rule_num), List.first(options))
      end)
      |> IO.inspect

#    result =
#      message
#      |> as_single_lines()
#      |> Enum.filter( fn(line) -> is_valid?(line, ruleset["0"], ruleset) end)
  end

  def int_or_string("\"" <> str) do
    {nil, String.first(str)}
  end
  def int_or_string(str) do
    index = String.to_integer(str)
    {index, nil}
  end

  def is_valid?(line, rule, ruleset) do
    rule
    |> Enum.with_index()
    |> Enum.all?(fn({next_rule, index}) ->
      rule_works?(next_rule, line, ruleset)
    end)
  end

  def rule_works?("\"" <> next_rule, line, ruleset) do
    String.first(next_rule) == String.first(line)
  end
  def rule_works?(next_rule, line, ruleset) do
    rule_works?(ruleset[next_rule], line, ruleset)
  end

  def part2(args) do
    result = as_single_lines(args)
  end
end
