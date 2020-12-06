defmodule AdventOfCode.Day04 do
  def extract_passport_map(string) do
    string
    |> String.split("\n\n")
    |> Enum.map(fn(chunk) ->
      String.split(chunk, ~r/\s+/m)
      |> Enum.map(fn(field) ->
        [key, val] = String.split(field, ":")
        {key, val}
      end)
      |> Map.new
    end)
  end

  def has_p1_keys?(map) do
    keys = Map.keys(map) |> Enum.sort
    # IO.inspect(keys)

    keys == ~w[byr cid ecl eyr hcl hgt iyr pid] ||
    keys == ~w[byr     ecl eyr hcl hgt iyr pid]
  end

  def byr_valid?(value) do String.to_integer(value) in 1920..2002 end
  def iyr_valid?(value) do String.to_integer(value) in 2010..2020 end
  def eyr_valid?(value) do String.to_integer(value) in 2020..2030 end

  def hgt_valid?(value) do _hgt_valid?(Integer.parse(value)) end
  def _hgt_valid?({num, "cm"}) do num in 150..193 end
  def _hgt_valid?({num, "in"}) do num in 59..76 end
  def _hgt_valid?(_) do false end

  def hcl_valid?("#" <> value) do Regex.match?(~r/^[0-9a-f]{6}$/, value) end
  def hcl_valid?(_) do false end

  def ecl_valid?(value) do value in ~w[amb blu brn gry grn hzl oth] end
  def pid_valid?(value) do Regex.match?(~r/^\d\d\d\d\d\d\d\d\d$/, value) end

  def is_valid_for_p2?(map) do
    has_p1_keys?(map) &&
      byr_valid?(map["byr"]) &&
      iyr_valid?(map["iyr"]) &&
      eyr_valid?(map["eyr"]) &&
      hgt_valid?(map["hgt"]) &&
      hcl_valid?(map["hcl"]) &&
      ecl_valid?(map["ecl"]) &&
      pid_valid?(map["pid"])
  end

  def part1(args) do
    result =
      extract_passport_map(args)
      |> Enum.reduce(%{valid_passports: 0}, fn(map, %{valid_passports: valid_passports}) ->
        case has_p1_keys?(map) do
          true -> %{valid_passports: valid_passports + 1}
          _ -> %{valid_passports: valid_passports}
        end
      end)

    result.valid_passports
  end

  def part2(args) do
    result =
      extract_passport_map(args)
      |> Enum.reduce(%{valid_passports: 0}, fn(map, %{valid_passports: valid_passports}) ->
        case is_valid_for_p2?(map) do
          true -> %{valid_passports: valid_passports + 1}
          _ -> %{valid_passports: valid_passports}
        end
      end)

    result.valid_passports
  end
end
