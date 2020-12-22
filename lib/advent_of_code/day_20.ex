defmodule AdventOfCode.Day20 do
  import AdventOfCode

  #  1951    2311    3079
  #  2729    1427    2473
  #  2971    1489    1171
  # 1951 * 3079 * 2971 * 1171 = 20899048083289

  def part1(args) do
    result =
      args
      |> as_doublespaced_paragraphs()
      |> Enum.reduce(%{}, fn(paragraph, acc) ->
        [tile_line | tile] = as_single_lines(paragraph)
        {tile_num, _} =
          tile_line
          |> String.slice(5..-1)
          |> Integer.parse()
        [top, right, bottom, left] = get_edges(tile)

        #IO.inspect([tile_num, top, right, bottom, left])
        acc
        |> add_row(top, tile_num, 0)
        |> add_row(right, tile_num, 1)
        |> add_row(bottom, tile_num, 2)
        |> add_row(left, tile_num, 3)
      end)
#      |> Enum.map(fn({k,v}) ->
#        case Enum.count(v) == 1 do
#          true -> IO.inspect({k, v})
#          _ -> nil
#        end
#      end)
      #|> IO.inspect()
      |> Enum.filter(fn(entry) ->
        case entry do
          nil -> false
          {k,v} -> Enum.count(v) == 1
        end
      end)
      |> Enum.sort(fn({line1, [{tile_num1, edge1}]}, {line2, [{tile_num2, edge2}]}) ->
        tile_num1 * 10 + edge1 >= tile_num2 * 10 + edge2
      end)
      |> Enum.map(fn({k,v}) ->
        IO.inspect({k, v})
      end)

    # Manually search for entries with 4 entries - which are corners
    # and multiply (we don't care which is which)
    # Example: 1171*1951*2971*3079 == 20899048083289
    # Real Thing: 2749*2713*1487*1063 == 11788777383197

    IO.puts("done")
  end

  def add_row(map, edge, tile_num, side) do
    {_, map} = Map.get_and_update(map, edge, fn(cur) ->
      _add_row(cur, {tile_num, side})
    end)
    edge = String.reverse(edge)
    side = side + 4 # 4+ is the reversed edge
    {_, map} = Map.get_and_update(map, edge, fn(cur) ->
      _add_row(cur, {tile_num, side})
    end)
    map
  end

  def _add_row(current, {tile_num, side}) do
    #IO.inspect([current, {tile_num, side}])
    case current do
      nil -> {current, [{tile_num, side}]}
      _ -> {current, [{tile_num, side} | current]}
    end
  end



  def get_edges(tile) do
    top = List.first(tile)
    bottom = List.last(tile)
    left =
      tile
      |> Enum.map(fn(line) -> String.slice(line, 0, 1) end)
      |> Enum.join()
    right =
      tile
      |> Enum.map(fn(line) -> String.slice(line, -1, 1) end)
      |> Enum.join()
    [top, right, bottom, left]
  end

  def part2(args) do
    result = as_single_lines(args)
  end
end
