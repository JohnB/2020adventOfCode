defmodule AdventOfCode.Day08 do
  # ip stands for Instruction Pointer
  def execute(program, ip \\ 0, accumulator \\ 0, visited \\ MapSet.new()) do
    %{op: op, delta: delta, index: ip} = program[ip]

    # Tentatively try the op
    {ip2, acc2} = case op do
      "nop" -> {ip + 1, accumulator}
      "acc" -> {ip + 1, accumulator + delta}
      "jmp" -> {ip + delta, accumulator}
    end

    # Exit it new position is not new to us
    looped = MapSet.member?(visited, ip2)
    past_end = ip2 >= Enum.count(program)
    case {looped, past_end} do
      {false, true} -> {:ok, acc2} # Program finished!
      {true, _} -> {:err, accumulator} # infinite loop
      _ -> execute(program, ip2, acc2, MapSet.put(visited, ip))
    end
  end

  def parse_program(instructions) do
    instructions
    |> String.trim
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.reduce(%{}, fn({instruction, index}, acc) ->
      op = String.slice(instruction, 0, 3)
      delta = String.slice(instruction, 4..-1) |> String.to_integer
      Map.put(acc, index, %{op: op, delta: delta, index: index})
    end)
  end

  def part1(instructions) do
    program = parse_program(instructions)

    {:err, acc} = execute(program)
    acc
  end

  def swap_instruction(program, ip_to_swap) do
    %{op: op, delta: delta, index: ip_to_swap} = program[ip_to_swap]
    replacement_op = case op do
      "nop" -> "jmp"
      "acc" -> "acc"
      "jmp" -> "nop"
    end
    Map.put(program, ip_to_swap, %{op: replacement_op, delta: delta, index: ip_to_swap})
  end

  def part2(instructions) do
    program = parse_program(instructions)
    op_count = Enum.count(program)

    bad_ip = Enum.find(0..op_count, fn(ip) ->
      fixed = swap_instruction(program, ip)
      case execute(fixed) do
        {:err, _} -> false
        {:ok, _} -> true
      end
    end)

    fixed = swap_instruction(program, bad_ip)
    {:ok, acc} = execute(fixed)
    acc
  end
end
