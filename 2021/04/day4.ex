defmodule Day4 do
  def input do
	File.stream!("input.txt")
	|> Enum.map(&String.trim/1)
  end

  def parse input do
	[numbers | rest] = input

	{parseNumbers(numbers), parseBoards(rest)}
  end
  
  def parseNumbers line do
	line
	|> String.trim
	|> String.split(",")
	|> Enum.map(&String.to_integer/1)
  end

  def parseBoards input do
	input
	|> Enum.filter(&(&1 != ""))
	|> Enum.chunk_every(5)
	|> Enum.map(
	  fn x -> x
		|> Enum.map(fn x -> x
		  |> String.split(" ")
		  |> Enum.filter(&(&1 != ""))
		  |> Enum.map(fn x -> {String.to_integer(x), false} end)
		end)
	  end)
  end

  def board do
	[
	  [{22, false}, {13, false}, {17, false}, {11, false}, {0, false}],
      [{8, false}, {2, false}, {23, false}, {4, false}, {24, false}],
      [{21, false}, {9, false}, {14, false}, {16, false}, {7, false}],
      [{6, false}, {10, false}, {3, false}, {18, false}, {5, false}],
      [{1, false}, {12, false}, {20, false}, {15, false}, {19, false}]
	]
  end

  def mark(number, board) do
	board
	|> Enum.map(fn x -> x
	  |> Enum.map(fn p = {n, _} ->
		if n == number
		  do {n, true}
		  else p end end)
	end)
  end

  def win? board do
	win_row?(board) || win_row?(transpose(board))
  end
  
  def win_row? board do
	board
	|> Enum.map(fn x -> x
	  |> Enum.map(fn x -> elem(x, 1) end)
	  |> Enum.all?
	end)
	|> Enum.any?
  end
  
  def transpose rows do
	rows
	|> List.zip
	|> Enum.map(&Tuple.to_list/1)
  end

  def example do
	"""
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""
|> String.split("\n")
  end

  def score(n, board) do 
	n * (board
	|> Enum.map(fn row -> row
	  |> Enum.filter(fn x -> not elem(x, 1) end)
	  |> Enum.map(fn {x,_} -> x end)
	  |> Enum.sum
	end)
	|> Enum.sum)
  end
	
  def part1 x do
	{numbers, boards} = parse x

	{n, winner} =
	Enum.reduce_while(numbers, boards, fn i, boards -> boards
	  |> Enum.map(fn board -> mark(i, board) end)
	  |> then fn boards ->
		if Enum.any?(boards, &win?/1) do
		  {:halt, {i, Enum.find(boards, &win?/1)}}
		else
		  {:cont, boards}
		end
	  end
	end)

	score(n, winner)
  end

  def part2 x do
	{numbers, boards} = parse x

	{n, winner} =
	Enum.reduce_while(numbers, boards, fn i, boards -> boards
	  |> Enum.map(fn board -> mark(i, board) end)
	  |> then fn boards ->
		if Enum.any?(boards, &win?/1) do
		  if length(boards) == 1 do
			{:halt, {i, Enum.find(boards, &win?/1)}}
		  else
			{:cont, Enum.filter(boards, fn x -> not win?(x) end)}
		  end
		else
		  {:cont, boards}
		end
	  end
	end)

	score(n, winner)
  end
end
