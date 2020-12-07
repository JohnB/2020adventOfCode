defmodule AdventOfCode.Day07 do
  def without_bag(string) do
    string
    |> String.replace(~r/\s+bags?.*/, "")
    |> String.trim()
  end

  def parse_contained("no other bags") do {0, ""} end
  def parse_contained(sub_bag) do Integer.parse(sub_bag) end

  # For a rule like this:
  #   light red bags contain 1 bright white bag, 2 muted yellow bags.
  # return
  #   "light red" => [
  #    %{bag_color: "bright white", count: 1},
  #    %{bag_color: "muted yellow", count: 2}
  #  ],
  def parse_rules(rules) do
    rules
    |> String.trim
    |> String.split("\n")
    |> Enum.reduce(%{}, fn(rule_text, acc) ->
      [bag_color | [contains]] = String.split(rule_text, " contain ")
      bag_color = without_bag(bag_color)
      sub_bags =
        contains
        |> String.replace("\.", "")
        |> String.split(", ")
        |> Enum.map(fn(sub_bag) ->
          {count, sub_type} = parse_contained(sub_bag)
          sub_type = without_bag(sub_type)
          %{count: count, bag_color: sub_type}
        end)
      Map.merge(acc, %{bag_color => sub_bags})
    end)
  end

  def contained_set(contents) do
    contents
    |> Enum.reduce(MapSet.new, fn(%{bag_color: bag_color}, acc) ->
      MapSet.put(acc, bag_color)
    end)
  end

  def can_contain(rules, looking_for) do
    rules
    |> Enum.reduce(MapSet.new, fn({bag_color, contained_bags}, acc) ->
      contains = contained_set(contained_bags)
      matching_colors = MapSet.intersection(looking_for, contains)
      case MapSet.size(matching_colors) do
        0 -> acc
        _ -> MapSet.put(acc, bag_color)
      end
    end)
  end

  # Recurse until our set of bag colors does not get bigger
  def loop_until_stasis(set, rules) do
    original_size = MapSet.size(set)
    result = MapSet.union(set, can_contain(rules, set))
    updated_size = MapSet.size(result)
    case original_size == updated_size do
      true -> set
      _ -> loop_until_stasis(result, rules) # recurse until we stop adding colors
    end
  end

  def part1(args) do
    rules = parse_rules(args)

    looking_for =
      MapSet.new
      |> MapSet.put("shiny gold")
    original_count = 1

    looking_for = loop_until_stasis(looking_for, rules)

    #IO.inspect(looking_for)
    MapSet.size(looking_for) - original_count
  end

  def count_all_bags(rules, color) do
    case rules[color] do
      nil -> 1
      _ -> 1 + Enum.reduce(rules[color], 0, fn(bag_hash, acc) ->
        acc + bag_hash[:count] * count_all_bags(rules, bag_hash[:bag_color])
      end)
    end
  end

  def part2(args) do
    rules = parse_rules(args)
    count_all_bags(rules, "shiny gold") - 1 # subtract one to not include ourselves
  end
end
