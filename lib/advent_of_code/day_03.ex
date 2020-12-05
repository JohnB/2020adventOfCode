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

  def count_collisions(string, delta_x, _delta_y) do
    %{trees_hit: trees_hit} =
      string
      |> String.trim()
      |> String.split("\n")
      |> Enum.reduce(%{trees_hit: 0, x: 0}, fn(line, acc) ->
        case String.slice(line, Integer.mod(acc.x, String.length(line)), 1) do
          "." -> %{trees_hit: acc.trees_hit    , x: acc.x + delta_x}
          "#" -> %{trees_hit: acc.trees_hit + 1, x: acc.x + delta_x}
#          _ -> acc # should never happen - watch it crash
        end
      end)

    trees_hit
  end

  def part1(args) do
    count_collisions(args, 3, 1)
  end

  def part2(args) do
    count_collisions(args, 1, 1) *
    count_collisions(args, 3, 1) *
    count_collisions(args, 5, 1) *
    count_collisions(args, 7, 1) *
    count_collisions(args, 3, 2)
  end
end
