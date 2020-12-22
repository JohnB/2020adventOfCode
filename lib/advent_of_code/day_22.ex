defmodule AdventOfCode.Day22 do
  import AdventOfCode

  def part1(args) do
    [p1cards, p2cards] = extract_decks(args)

    IO.inspect([p1cards, p2cards])
    winner = combat(p1cards, p2cards)

    winner
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reduce(0, fn({card, index}, acc) -> acc + card * (index + 1) end)
  end

  def extract_decks(args) do
    [player1 | player2] = as_doublespaced_paragraphs(args)
    p1cards =
      player1
      |> as_single_lines()
      |> Enum.slice(1..-1)
      |> Enum.map(fn(str) -> String.to_integer(str) end)
    p2cards =
      player2
      |> List.first()
      |> as_single_lines()
      |> Enum.slice(1..-1)
      |> Enum.map(fn(str) -> String.to_integer(str) end)

    [p1cards, p2cards]
  end

  def combat([], p2) do
    p2
  end

  def combat(p1, []) do
    p1
  end

  def combat([p1 | p1rest], [p2 | p2rest]) do
    IO.inspect([p1, p1rest, p2, p2rest])
    case p1 > p2 do
      true -> combat(p1rest ++ [p1, p2], p2rest)
      _  -> combat(p1rest, p2rest ++ [p2, p1])
    end
  end

  ##########################

  def part2(args) do
    [p1cards, p2cards] = extract_decks(args)

    IO.inspect([p1cards, p2cards])
    {cards, winner} = combat2(p1cards, p2cards, [])

    cards
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn({card, index}, acc) -> acc + card * (index + 1) end)
  end

  def combat2([], p2, history) do
    {p2, :p2}
  end

  def combat2(p1, [], history) do
    {p1, :p1}
  end

  def combat2(p1cards, p2cards, history) do
    hist_entry = [p1cards, p2cards]
    case Enum.member?(history, hist_entry) do
      true -> {p1cards, :p1} |> IO.inspect(label: "loop")
      _ -> _combat2(p1cards, p2cards, history ++ [hist_entry])
    end
  end

  def _combat2(p1cards = [p1 | p1rest], p2cards = [p2 | p2rest], history) do
    case Enum.count(p1rest) >= p1 && Enum.count(p2rest) >= p2 do
      true -> recurse(p1cards, p2cards, history)
      _ -> _combat2a(p1cards, p2cards, history)
    end
  end

  def recurse(p1cards = [p1 | p1rest], p2cards = [p2 | p2rest], prev_history) do
    IO.inspect(["recursing"])
    {cards, winner} = combat2(Enum.slice(p1rest, 0, p1), Enum.slice(p2rest, 0, p2), [])
    |> IO.inspect(label: "end recurse")

    case winner == :p1 do
      true -> combat2(p1rest ++ [p1, p2], p2rest, prev_history)
      _  -> combat2(p1rest, p2rest ++ [p2, p1], prev_history)
    end
  end

  def _combat2a([p1 | p1rest], [p2 | p2rest], history) do
    IO.inspect([p1, p1rest, p2, p2rest])
    IO.inspect(history, label: "history")
    case p1 > p2 do
      true -> combat2(p1rest ++ [p1, p2], p2rest, history)
      _  -> combat2(p1rest, p2rest ++ [p2, p1], history)
    end
  end

end
