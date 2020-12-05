defmodule AdventOfCode.Day04 do
  def has_p1_keys?(map) do
    keys = Map.keys(map) |> Enum.sort
    # IO.inspect(keys)

    keys == ~w[byr cid ecl eyr hcl hgt iyr pid] ||
    keys == ~w[byr     ecl eyr hcl hgt iyr pid]
  end

  def part1(args) do
    result = args
             |> String.split("\n\n")
             |> Enum.reduce(%{valid_passports: 0}, fn(chunk, %{valid_passports: valid_passports}) ->
      data =
        String.split(chunk, ~r/\s+/m)
        |> Enum.map(fn(field) ->
          [key, val] = String.split(field, ":")
          {key, val}
        end)
        |> Map.new

      case has_p1_keys?(data) do
        true -> %{valid_passports: valid_passports + 1}
        _ -> %{valid_passports: valid_passports}

      end
    end)

    result.valid_passports
  end

  def part2(_args) do
  end
end
