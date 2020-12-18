defmodule AdventOfCode.Day16 do
  import AdventOfCode

  def part1(args) do
    [ruleset, your_ticket, other_tix] = parse_inputs(args)

    other_tix
    |> Enum.reduce([], fn(values, acc1) ->
      values
      |> Enum.reduce(acc1, fn(value, acc2) ->
        case valid_somewhere?(value, ruleset) do
          true -> acc2
          _ -> [value | acc2]
        end
      end)
    end)
    |> Enum.sum()
  end

  def parse_inputs(args) do
    [rules, yours, others] =
      as_doublespaced_paragraphs(args)

    ruleset =
      rules
      |> String.split("\n")
      |> Enum.reduce(%{}, fn(line, acc) ->
        [name, values] =
          line
          |> String.split(": ")
        ranges =
          values
          |> String.split(" or ")
          |> Enum.map(fn(from_to) ->
            [from, too] = String.split(from_to, "-")
            from = String.to_integer(from)
            too = String.to_integer(too)
            from..too
          end)
        Map.put(acc, name, ranges)
      end)
      #|> IO.inspect()

    your_ticket =
      yours
      |> String.replace("your ticket:\n", "")
      |> String.split(",")
      |> Enum.map(fn(value) -> String.to_integer(value) end)
      #|> IO.inspect()

    other_tix =
      others
      |> String.replace("nearby tickets:\n", "")
      |> String.split("\n")
      |> Enum.map(fn(line) ->
        line
        |> String.split(",")
        |> Enum.map(fn(value) -> String.to_integer(value) end)
      end)
      #|> IO.inspect()

    [ruleset, your_ticket, other_tix]
  end

  def valid_somewhere?(value, ruleset) do
    ruleset
    |> Map.values()
    |> Enum.any?(fn(ranges) ->
      ranges
      |> Enum.any?(fn(range) ->
        #IO.inspect(["value in range", value, range])
        value in range
      end)
    end)
  end

  def part2(args) do
    [ruleset, your_ticket, other_tix] = parse_inputs(args)

    valid_tix =
      other_tix
      |> Enum.filter(fn(values) ->
        values
        |> Enum.all?(fn(value) ->
          valid_somewhere?(value, ruleset)
        end)
      end)
      #|> IO.inspect()

    columns = invert(valid_tix)
#      |> IO.inspect()

    rule_order =
      ruleset
      |> IO.inspect(label: "ruleset")
      |> Enum.sort_by(fn({name, ranges}) -> range_size(ranges) end)
      |> IO.inspect(label: "ruleset")
      #|> Enum.with_index()
      |> Enum.reduce([], fn({name, ranges}, acc) ->
        IO.inspect(acc, label: "acc")
        acc_cols = Enum.map(acc, fn({name, col_num}) -> col_num end)
        {_matching_column, rule_index} =
          columns
          |> Enum.with_index()
          |> Enum.sort_by(fn({col, c_index}) -> negative_column_span(col) end)
          #|> Enum.reverse()
          |> IO.inspect(label: "col&index")
          |> Enum.find(fn({col, c_index}) ->
            case c_index in acc_cols do
              true -> false
              _ -> col_is_ok?(col, ranges)
            end
          end)
#          |> IO.inspect(label: "matching column")
#        IO.inspect({name, rule_index}, label: "found column?")

        [{name, rule_index} | acc]
      end)
      |> Enum.reverse

    IO.inspect(your_ticket, label: "your_ticket")

    rule_order
    |> IO.inspect(label: "rule_order???")
    |> Enum.reduce(1, fn({name, rule_index}, acc) ->
#      IO.inspect([name, rule_index, acc, your_ticket])
      case Regex.match?(~r/departure /, name) do
        true -> (acc * Enum.at(your_ticket, rule_index)) |> IO.inspect(label: "#{name} (#{rule_index})")
        _ -> acc
      end
    end)
  end

  def range_size(ranges) do
    Enum.map(ranges, fn(range) ->
      Enum.count(range)
    end)
    |> Enum.sum()
  end

  # [45,56,65] would yield -20
  def negative_column_span(col) do
    sorted = Enum.sort(col)
    List.first(sorted) - List.last(sorted)
  end

  def col_is_ok?(col, ranges) do
    col
    |> Enum.all?(fn(value) ->
      ranges
      |> Enum.any?(fn(range) -> value in range end)
    end)

  end

  def invert(list) do
    attach_row(list, [])
  end

  # Next functions lifted from http://langintro.com/elixir/article2/
  def attach_row([], result) do  # handle ending case first
    result
  end
  def attach_row(row_list, result) do
    [first_row | other_rows] = row_list
    new_result = make_column(first_row, result)
    attach_row(other_rows, new_result)
  end
  def make_column([], result) do # my job here is done
    result
  end
  def make_column(row, []) do
    [first_item | other_items] = row
    [[first_item] | make_column(other_items, [])]
  end
  def make_column(row, result) do
    [first_item | other_items] = row
    [first_row | other_rows] = result
    [[first_item | first_row] | make_column(other_items, other_rows)]
  end
end
