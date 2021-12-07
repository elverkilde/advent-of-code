defmodule Day2 do
  def input do
	File.stream!("input.txt")
	|> Enum.map(&parse/1)
  end

  def parse line do
	[direction, rest] = String.split(line, " ")
	{dist, _} = Integer.parse(rest)
	{String.to_atom(direction), dist}
  end

  def move({:forward, d}, {x, y}), do: {x+d, y}
  def move({:up, d}, {x, y}), do: {x, y-d}
  def move({:down, d}, {x, y}), do: {x, y+d}
  
  def part1 x do
	x
	|> Enum.reduce({0,0}, &move/2)
	|> then fn {x,y} -> x*y end
  end

  def move_aim({:forward, d}, {x, y, aim}), do: {x+d, y+d*aim, aim}
  def move_aim({:up, d}, {x, y, aim}), do: {x, y, aim-d}
  def move_aim({:down, d}, {x, y, aim}), do: {x, y, aim+d}
  
  def part2 x do
	x
	|> Enum.reduce({0,0,0}, &move_aim/2)
	|> then fn {x,y, _} -> x*y end
  end
end
