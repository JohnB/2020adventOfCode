defmodule AdventOfCode.Day21 do
  import AdventOfCode

  def part1(args) do
    result =
      as_single_lines(args)
      |> Enum.reduce(%{}, fn(line, acc) ->
        [ingredients, contains] = String.split(line, " (contains ")
        ingredients =
          ingredients
          |> String.split(" ")
          |> Enum.sort()
        contains =
          contains
          |> String.replace(")", "")
          |> String.split(", ")
          |> Enum.sort()
        Enum.reduce(contains, acc, fn(allergen, acc2) ->
          {_, acc2} = Map.get_and_update(acc2, allergen, fn(current) ->
            case current do
              nil -> {current, [ingredients]}
              _ -> {current, [ingredients | current]}
            end
          end)
          acc2
        end)
      end)
      |> Enum.reduce(0, fn({allergen, ingredients}, acc) ->
        IO.puts(allergen)
        ingredients
        |> IO.inspect(label: "before dupe removal")
        |> remove_dupes()
        |> IO.inspect(label: " after dupe removal")
        |> Enum.count()
      end)
  end

  def remove_dupes(array, set \\ MapSet.new())
  def remove_dupes([], set) do
    set
  end
  def remove_dupes([ingredients1 | rest], set) do
    ingredients1 = MapSet.new(ingredients1)
    set = MapSet.difference(MapSet.union(set, ingredients1), MapSet.intersection(set, ingredients1))
    remove_dupes(rest, set)
  end

  def part2(args) do
    result = as_single_lines(args)
  end
end
