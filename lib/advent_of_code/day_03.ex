defmodule AdventOfCode.Day03 do
#  Day 3: Toboggan Trajectory
#  You start on the open square (.) in the top-left corner
#  and need to reach the bottom (below the bottom-most row on your map).
#  The toboggan can only follow a few specific slopes
#  start by counting all the trees you would encounter for the slope right 3, down 1:
#  From your starting position at the top-left, check the position that is right 3 and down 1.
#  Then, check the position that is right 3 and down 1 from there, and so on
#  until you go past the bottom of the map.
#  The locations you'd check in the above example are marked here with O
#  where there was an open square and X where there was a tree:
#
#    # Starting at the top-left corner of your inpul map
#    # and following a slope of right 3 and down 1,
#    # how many trees would you encounter?

  def count_collisions(string, delta_x, delta_y) do
    %{trees_hit: trees_hit} =
      string
      |> String.trim()
      |> String.split("\n")
      |> Enum.reduce(%{trees_hit: 0, x: 0, y: 0}, fn(line, %{trees_hit: trees_hit, x: x, y: y}) ->
        current_square = (Integer.mod(y, delta_y) == 0) && String.slice(line, Integer.mod(x, String.length(line)), 1) ||"x"
        case current_square do
          "." -> %{trees_hit: trees_hit    , x: x + delta_x, y: y + 1}
          "#" -> %{trees_hit: trees_hit + 1, x: x + delta_x, y: y + 1}
          "x" -> %{trees_hit: trees_hit    , x: x,           y: y + 1} # skipped row
        end
      end)

    trees_hit
  end

  def part1(args) do
    count_collisions(args, 3, 1)
  end

  def part2(args) do
    c11 = count_collisions(args, 1, 1)
    c31 = count_collisions(args, 3, 1)
    c51 = count_collisions(args, 5, 1)
    c71 = count_collisions(args, 7, 1)
    c12 = count_collisions(args, 1, 2)

    c11 * c31 * c51 * c71 * c12
  end
end
