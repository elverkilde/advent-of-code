defmodule Day5 do
  def input do
	File.stream!("input.txt")
	|> Enum.map(&parse/1)
  end

  def parse line do
	line
	|> String.trim
	|> then &parse_line/1
  end

  def parse_point str do
	[x, y] = str
	|> String.split(",")
	|> Enum.map(&String.to_integer/1)

	{x,y}
  end

  def parse_line str do
	[a, "->", b] = String.split(str, " ")
	{parse_point(a), parse_point(b)}
  end
  
  def example do
"""
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""
|> String.split("\n") |> Enum.filter(fn x -> x != "" end)
  end

  def draw {{x1, y}, {x2, y}} do
	Enum.to_list(x1..x2)
	|> Enum.map(fn x -> {x,y} end)
  end

  def draw {{x, y1}, {x, y2}} do
	Enum.to_list(y1..y2)
	|> Enum.map(fn y -> {x,y} end)
  end

  def draw {{x1,y1}, {x2, y2}} do
	Enum.zip([
	  Enum.to_list(x1..x2),
	  Enum.to_list(y1..y2)
	])
  end

  def count lines do
	(((lines
	  |> then &List.flatten/1)
	  |> then &Enum.frequencies/1)
	  |> then &Map.values/1)
	|> Enum.count(fn x -> x > 1 end)
  end
	  
  def part1 x do
	x
	|> Enum.filter(fn {{x1,y1}, {x2,y2}} -> x1 == x2 || y1 == y2 end)
	|> Enum.map(&draw/1)
	|> then &count/1
  end

  def part2 x do
	x
	|> Enum.map(&draw/1)
	|> then &count/1
  end
end
