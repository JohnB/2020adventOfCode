defmodule AdventOfCode.Day14 do
  import AdventOfCode

  @zeros [
    "0", "0", "0", "0", "0", "0", "0", "0", "0",
    "0", "0", "0", "0", "0", "0", "0", "0", "0",
    "0", "0", "0", "0", "0", "0", "0", "0", "0",
    "0", "0", "0", "0", "0", "0", "0", "0", "0",
  ]

  def part1(args) do
    start = %{mask: []}
    result =
      as_single_lines(args)
      |> Enum.reduce(start, fn(line, acc) ->
        words = String.split(line, " = ", trim: true)
        case List.first(words) do
          "mask" -> %{acc | mask: List.last(words) |> String.split("", trim: true) }
          _ -> apply1(acc, words)
        end
      end)
      |> Enum.reduce(0, fn({k, v}, acc) ->
        case k do
          :mask -> acc
          _ -> acc + String.to_integer(v, 2)
        end
      end)
  end

  def part2(args) do
    start = %{mask: []}
    result =
      as_single_lines(args)
      |> Enum.reduce(start, fn(line, acc) ->
        words = String.split(line, " = ", trim: true)
        case List.first(words) do
          "mask" -> %{acc | mask: List.last(words) |> String.split("", trim: true) }
          _ -> apply2(acc, words)
        end
      end)
      |> IO.inspect(label: "ready?")
      |> Enum.reduce(0, fn({k, v}, acc) ->
        IO.inspect([k, v, acc])
        case k do
          :mask -> acc
          _ -> acc + v #String.to_integer(v, 2)
        end
      end)
  end

  def apply2(acc = %{mask: mask}, [store_cmd, value]) do
    # "mem[8]" means that 8 is at position 4
    {address, _junk} = String.slice(store_cmd, 4..-1) |> Integer.parse()
    binary =
      (@zeros ++ Integer.digits(address, 2))
      |> Enum.take(-36)

    updated_memory =
      find_addrs(mask, binary, "")
      |> IO.inspect
      |> Enum.reduce(%{}, fn(addr, map) ->
        Map.put(map, addr, String.to_integer(value))
      end )

      Map.merge(acc, updated_memory)
  end

  def enumerate_addrs([], result) do
#    IO.inspect(result, label: "enumerate_addrs hit bottom")

    addr =
      result
      |> Enum.join
      |> String.to_integer(2)
      |> IO.inspect(label: "bottom")

    [addr]
  end

  def enumerate_addrs([addr0 | addr_rest], so_far) do
#    IO.inspect([addr0, addr_rest, so_far])
    case addr0 do
      "X" -> enumerate_addrs(["1" | addr_rest], so_far) ++ enumerate_addrs(["0" | addr_rest], so_far)
      _ -> enumerate_addrs(addr_rest, so_far ++ [addr0])
    end
  end

  def find_addrs([], [], acc ) do
#    IO.inspect(acc, label: "should have floating bits")
    enumerate_addrs(String.split(acc, "", trim: true), [])
#    |> IO.inspect(label: "end of find_addrs")
  end

  def find_addrs([mask0 | mask_rest], [bit | other_bits], acc ) do
    case mask0 do
      "0" -> find_addrs(mask_rest, other_bits, acc <> "#{bit}")
      "1" -> find_addrs(mask_rest, other_bits, acc <> "1")
      "X" -> find_addrs(mask_rest, other_bits, acc <> "X")
    end
  end

  def masked_values(mask, value) do
    binary =
      (@zeros ++ Integer.digits(value, 2))
      |> Enum.take(-36)

    apply_mask(mask, binary, [])
    |> Enum.join
  end

  ### part1 functions

  def apply1(acc = %{mask: mask}, [store_cmd, value]) do
    # "mem[8]" means that 8 is at position 4
    {address, _junk} = String.slice(store_cmd, 4..-1) |> Integer.parse()
    Map.put(acc, address, masked_value(mask, String.to_integer(value)))
    |> IO.inspect
  end

  def masked_value(mask, value) do
    binary =
      (@zeros ++ Integer.digits(value, 2))
      |> Enum.take(-36)

    apply_mask(mask, binary, [])
    |> Enum.join
  end

  def apply_mask([], [], acc ) do acc end
  def apply_mask([mask0 | mask_rest], [bit | other_bits], acc ) do
    case mask0 do
      "X" -> apply_mask(mask_rest, other_bits, acc ++ [bit])
      _ -> apply_mask(mask_rest, other_bits, acc ++ [mask0])
    end
  end
end
