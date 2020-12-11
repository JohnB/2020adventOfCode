defmodule AdventOfCode.Day11 do
  import AdventOfCode

  # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
  # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
  # Otherwise, the seat's state does not change.

  def adjacent_squares(pos, width) do
    [
      pos - width - 1, pos - width, pos - width + 1,
      pos - 1,                      pos + 1,
      pos + width - 1, pos + width, pos + width + 1,
    ]
  end

  def as_string(room, width) do
    count = Enum.count(room)
    Enum.map(0..(count - 1), fn(pos) ->
      case Integer.mod(pos, width) == 0 do
        true -> "\n" <> room[pos]
        _ -> room[pos]
      end
    end)
    |> Enum.join()
  end

  def apply_rules(room, width) do
    room
    |> Enum.reduce(%{}, fn({pos, value}, acc) ->
      num_occupied_neighbors =
        adjacent_squares(pos, width)
        |> Enum.reduce(0, fn(neighbor_index, acc) ->
          case room[neighbor_index] do
            "#" -> acc + 1
            _ -> acc
          end
        end)
      num_occupied_neighbors = (num_occupied_neighbors > 4) && 4 || num_occupied_neighbors

      case {value, num_occupied_neighbors} do
        {"L", 0} -> Map.put(acc, pos, "#") # occupied
        {"#", 4} -> Map.put(acc, pos, "L") # emptied out
        {_, _} -> Map.put(acc, pos, value)
      end
    end)
  end

  def iterate(room, width) do
    room2 = apply_rules(room, width)
    case room == room2 do
      true -> room2
      _ -> iterate(room2, width)
    end
  end

  def build_room(args) do
    # put the room into a hash mapped as a single long arrry(ish)
    # "X" - off board
    # Put an off-board marker all around the edges
    lines = as_single_lines(args)
    width = 2 + (List.first(lines) |> String.length()) # includes border
    top_row =
      (0..(width - 1))
      |> Enum.reduce(%{}, fn(x, acc) ->
        Map.put(acc, x, "X")
      end)

    top_and_middle =
      lines
      |> Enum.with_index
      |> Enum.reduce(top_row, fn({line, row_index}, row_acc) ->
        String.split("X" <> line <> "X", "",  trim: true)
        |> Enum.with_index
        |> Enum.reduce(row_acc, fn({char, col_index}, col_acc) ->
          Map.put(col_acc, (row_index + 1) * width + col_index, char)
        end)
      end)

    count = Enum.count(top_and_middle)
    room =
      (count..(count + width - 1))
      |> Enum.reduce(top_and_middle, fn(x, acc) ->
        Map.put(acc, x, "X")
      end)

    {room, width}
  end

  def part1(args) do
    {room, width} = build_room(args)

    final_room = iterate(room, width)
    final_string = as_string(final_room, width)
    IO.puts(final_string)
    (String.split(final_string, "#") |> Enum.count()) - 1
  end

  def iterate2(room, width) do
    room2 = apply_rules2(room, width)
    case room == room2 do
      true -> room2
      _ -> iterate2(room2, width)
    end
  end

  def visible_neighbors_this_dir(room, pos, delta) do
    case {room[pos], room[pos + delta]} do
      {_, "L"} -> 0
      {"X", _} -> 0
      {_, "X"} -> 0
      {nil, _} -> 0
      {_, nil} -> 0
      {_, "#"} -> 1
      _ -> visible_neighbors_this_dir(room, pos + delta, delta)
    end
  end

  def apply_rules2(room, width) do
    room
    |> Enum.reduce(%{}, fn({pos, value}, acc) ->
      visible_occupied_neighbors =
        visible_neighbors_this_dir(room, pos, -width - 1) +
        visible_neighbors_this_dir(room, pos, -width    ) +
        visible_neighbors_this_dir(room, pos, -width + 1) +
        visible_neighbors_this_dir(room, pos, -1        ) +
        visible_neighbors_this_dir(room, pos, 1         ) +
        visible_neighbors_this_dir(room, pos, width - 1 ) +
        visible_neighbors_this_dir(room, pos, width     ) +
        visible_neighbors_this_dir(room, pos, width + 1 )

      visible_occupied_neighbors = (visible_occupied_neighbors > 5) && 5 || visible_occupied_neighbors

      case {value, visible_occupied_neighbors} do
        {"L", 0} -> Map.put(acc, pos, "#") # occupied
        {"#", 5} -> Map.put(acc, pos, "L") # emptied out
        {_, _} -> Map.put(acc, pos, value)
      end
    end)
  end

  def part2(args) do
    {room, width} = build_room(args)

    final_room = iterate2(room, width)
    final_string = as_string(final_room, width)
    IO.puts(final_string)
    (String.split(final_string, "#") |> Enum.count()) - 1
  end
end
