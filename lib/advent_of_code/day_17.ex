defmodule AdventOfCode.Day17 do
  import AdventOfCode

  @active "#"
  @inactive "."
  @sphere [
    {-1, -1, -1},  {0, -1, -1},  {1, -1, -1},
    {-1,  0, -1},  {0,  0, -1},  {1,  0, -1},
    {-1,  1, -1},  {0,  1, -1},  {1,  1, -1},

    {-1, -1,  0},  {0, -1,  0},  {1, -1,  0},
    {-1,  0,  0},                {1,  0,  0},
    {-1,  1,  0},  {0,  1,  0},  {1,  1,  0},

    {-1, -1,  1},  {0, -1,  1},  {1, -1,  1},
    {-1,  0,  1},  {0,  0,  1},  {1,  0,  1},
    {-1,  1,  1},  {0,  1,  1},  {1,  1,  1},
  ]

  def part1(args) do
    #IO.inspect(sphere_iterator(0), label: "sphere0")
    #IO.inspect(sphere_iterator(1), label: "sphere1")

    # Store in a map, with keys of {x,y,z}
    slab =
      as_single_lines(args)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn({line, y}, acc0) ->
        String.split(line, "", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn({char, x}, acc1) ->
          Map.put(acc1, {x-1, y-1, 0}, char)
        end)
        |> Map.merge(acc0)
      end)
#      |> IO.inspect(label: "Start")
      |> as_tables(0)

    result =
      1..6
      |> Enum.reduce({slab, %{}}, fn(iteration, {oldslab, newslab}) ->
        IO.inspect({oldslab, newslab})
        map =
          sphere_iterator(iteration)
          |> Enum.reduce(%{}, fn(location, acc) ->
            # count active neighbors
            [active_neighbors, current_value] = count_active(slab, location)
                               |> IO.inspect()

            case {active_neighbors, current_value} do
              {3, @active} -> Map.put(acc, location, @active)
              {2, @active} -> Map.put(acc, location, @active)
              {3, @inactive} -> Map.put(acc, location, @active)
              _ -> Map.put(acc, location, @inactive)
            end
          end)
#          |> IO.inspect(label: "Iteration #{iteration}}")
          |> as_tables(iteration)

        {map, %{}}
      end)

    active_count =
      result
      |> Map.values()
      |> Enum.join("")
      |> String.split(@active)
      |> Enum.count(@active)

    active_count - 1
  end

  def as_tables(slab, iteration) do
    Enum.map((-iteration - 1)..(iteration+1), fn(z) ->
      Enum.map((-iteration - 1)..(iteration+1), fn(y) ->
        Enum.reduce((-iteration - 1)..(iteration+1), [], fn(x, acc) ->
          [(slab[{x, y, z}] || "?") | acc]
        end)
        |> Enum.join("")
        |> IO.puts
      end)
    end)
  end

  def sphere_iterator(iteration) do
    Enum.reduce((-iteration - 1)..(iteration+1), [], fn(x, accx) ->
      Enum.reduce((-iteration - 1)..(iteration+1), [], fn(y, accy) ->
        Enum.reduce((-iteration - 1)..(iteration+1), [], fn(z, accz) ->
          case {x,y,z} do
            {0,0,0} -> accz
            _ -> [{x,y,z} | accz]
          end
        end) ++ accy
      end) ++ accx
    end)
  end

  def count_active(slab, location = {x,y,z}) do
    count =
      @sphere
      |> Enum.reduce(0, fn({dx,dy,dz}, acc) ->
        IO.inspect([{dx,dy,dz}, acc, slab])
        index = {x+dx,y+dy,z+dz}
        IO.inspect(index)
        case slab[index] do
          @active -> acc + 1
          _ -> acc
        end
      end)
    [count, slab[location]]
  end

  def part2(args) do
    result = as_single_lines(args)
  end
end
