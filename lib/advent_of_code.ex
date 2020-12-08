defmodule AdventOfCode do
  @moduledoc """
  Documentation for AdventOfCode.
  """

  # Given "09" and CLI arguments, read input from the appropriate file:
  # FILE              CLI
  # d09.example.txt   mix d09.p1 -e
  # d09.input.txt     mix d09.p1
  # d09.example2.txt  mix d09.p1 -e -2
  # d09.input2.txt    mix d09.p1 -2
  def get_input(day_string, args) do
    example = Enum.member?(args, "-e")
    version = Enum.member?(args, "-2") && "2" || ""

    result_type = example && "example#{version}" || "input#{version}"
    filename = "lib/mix/tasks/d#{day_string}.#{result_type}.txt"
    input = File.read!(filename)
    IO.puts("Read #{String.length(input)} bytes from #{filename}")
    input
  end

  # as_single_lines(args, fn(line) -> end)
  def as_single_lines(multiline_text) do
    multiline_text
    |> String.split("\n")
  end

  # as_doublespaced_paragraphs(args, fn(paragraph) -> end)
  def as_doublespaced_paragraphs(multiline_text) do
    multiline_text
    |> String.split("\n\n")
  end

  # as_paragraph_lines(paragraph, fn(line) -> end)
  def as_paragraph_lines(paragraph) do
    as_single_lines(paragraph)
  end

  # delimited_by_spaces(text, fn(array) -> end)
  def delimited_by_spaces(text) do
    String.split(~r/\s+/)
  end

  # delimited_by_colons(text)
  def delimited_by_colons(text) do
    String.split(~r/\:/)
  end

  # split_at_intervals(chars, end_offsets)
  # Example:
  #   split_at_intervals("abc123def", [3,6,9]) =>
  #   ["abc", "123", "def"]
#  def split_at_offsets(chars, []) do [] end
#  def split_at_offsets(chars, [next_offset | rest]) do
#    _split_at_offsets(chars, end_offsets)
#    |> Enum.reverse()
#  end
#  def _split_at_offsets(chars, [], tail \\ []) do tail end
#  def _split_at_offsets(chars, [next_offset | rest], tail) do
#    _split_at_offsets(
#      String.slice(chars, next_offset..-1),
#      rest,
#      [String.slice(chars, 0, next_offset) | tail]
#    )
#  end
end
