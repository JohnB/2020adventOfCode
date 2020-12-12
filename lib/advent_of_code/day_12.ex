defmodule AdventOfCode.Day12 do
  import AdventOfCode

  def left(dir, angle) do
      l_from = %{
        "N" => "W",
        "E" => "N",
        "S" => "E",
        "W" => "S",
      }
    dir = l_from[dir]
    case angle do
      90 -> dir
      _ -> left(dir, angle - 90)
    end
  end

  def right(dir, angle) do
      r_from = %{
        "N" => "E",
        "E" => "S",
        "S" => "W",
        "W" => "N",
      }

    dir = r_from[dir]
    case angle do
      90 -> dir
      _ -> right(dir, angle - 90)
    end
  end

  def part1(args) do
    start = %{dir: "E", x: 0, y: 0}

    result = as_single_lines(args)
    |> Enum.reduce(start, fn(line, acc = %{dir: dir, x: x, y: y}) ->
        IO.inspect([line, acc])
        code = String.slice(line, 0, 1)
        code = (code == "F") && dir || code

        num = String.slice(line, 1..-1) |> String.to_integer

        case code do
            "N" -> %{acc | y: y + num}
            "E" -> %{acc | x: x + num}
            "S" -> %{acc | y: y - num}
            "W" -> %{acc | x: x - num}
            "L" -> %{acc | dir: left(dir, num)}
            "R" -> %{acc | dir: right(dir, num)}
        end
    end)
    |> IO.inspect

    Kernel.abs(result.x) + Kernel.abs(result.y)
  end

  ###

  def wleft(acc = %{dir: dir, x: x, y: y, wx: wx, wy: wy}, angle) do
    # s: 2,1 w: 5, 3  => w: 0, 4 (x+wy-y, y+wx-x)
    l90 = %{acc | wx: -wy, wy: wx}

    case angle do
      90 -> l90
      _ -> wleft(l90, angle - 90)
    end
  end

  def wright(acc = %{dir: dir, x: x, y: y, wx: wx, wy: wy}, angle) do
    # s: 2,1 w: 5,3  => w: 4,-2 (x+wy-y, y-wx+x)
    r90 = %{acc | wx: wy, wy: -wx}

    case angle do
      90 -> r90
      _ -> wright(r90, angle - 90)
    end
  end

  def to_waypoint(acc = %{dir: dir, x: x, y: y, wx: wx, wy: wy}, multiplier) do
    # dx = wx - x
    # dy = wy - y
    # %{acc | x: x + dx * multiplier, y: y + dy * multiplier}
    %{acc | x: x + wx * multiplier, y: y + wy * multiplier}
    |> IO.inspect(label: "moved")
  end

  def part2(args) do
    start = %{dir: "E", x: 0, y: 0, wx: 10, wy: 1}

    result = as_single_lines(args)
    |> Enum.reduce(start, fn(line, acc = %{dir: dir, x: x, y: y, wx: wx, wy: wy}) ->
        IO.inspect([line, acc], label: "? ")
        code = String.slice(line, 0, 1)

        num = String.slice(line, 1..-1) |> String.to_integer

        case code do
            "N" -> %{acc | wy: wy + num}
            "E" -> %{acc | wx: wx + num}
            "S" -> %{acc | wy: wy - num}
            "W" -> %{acc | wx: wx - num}
            "L" -> wleft(acc, num)
            "R" -> wright(acc, num)
            "F" -> to_waypoint(acc, num)
        end
    end)
    |> IO.inspect

    Kernel.abs(result.x) + Kernel.abs(result.y)
  end
end
