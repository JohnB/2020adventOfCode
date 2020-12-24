defmodule AdventOfCode.Day24 do
  import AdventOfCode
  require Integer

  @width 1000
  # NorthWest is +1000 as an integer index into a hex's offset from
  # the reference tile (at 0).
  @offsets %{
    "e" => 1,
    "j" => -@width,     # normalized from "se"
    "k" => -@width - 1, # sw
    "w" => -1,
    "l" => @width,      # nw
    "m" => @width + 1   # ne
  }

  def part1(args) do
    convert_to_map(args)
    |> count_black_tiles()
  end

  def normalize_directions(paths) do
    paths
    |> String.replace("se", "j")
    |> String.replace("sw", "k")
    |> String.replace("nw", "l")
    |> String.replace("ne", "m")
  end

  def calculate_destinations(paths) do
    paths
    |> Enum.reduce(%{}, fn(path, acc) ->
      destination =
        path
        |> String.split("", trim: true)
        |> Enum.map(fn(char) -> @offsets[char] end)
        |> Enum.sum()
      {_, acc} = Map.get_and_update(acc, destination, fn(current_value) ->
        case current_value do
          nil -> {current_value, [path]}
          list -> {current_value, [path] ++ list}
        end
      end)
      acc
    end)
  end

  def count_black_tiles(map) do
    map
    |> Enum.reduce(0, fn({k,v}, acc) ->
      is_black?(v) && (acc + 1) || acc
    end)
  end

  def is_black?(list) do
    list
    |> Enum.count()
    |> Integer.is_odd()
  end

  def is_white?(list) do
    !is_black?(list)
  end

  def convert_to_map(args) do
    result =
      args
      |> normalize_directions()
      |> as_single_lines()
      |> calculate_destinations()
  end

  def part2(args) do
    IO.inspect(@offsets)

    map = convert_to_map(args)
          |> IO.inspect()

    apply_rules(map, 10)
    |> count_black_tiles()
  end

  def apply_rules(map, 0) do
    map
  end

  def apply_rules(map, iterations) do
    #    Any black tile with zero or more than 2 black tiles immediately
    #    adjacent to it is flipped to white.
    #    Any white tile with exactly 2 black tiles immediately adjacent
    #    to it is flipped to black.
    #
    map =
      map
      |> Enum.reduce(%{}, fn({k,v}, acc) ->
        acc
      end)
  end

  def apply_rule(map, iterations) do
  end

  def apply_rules(map, iterations) do
  end
end
