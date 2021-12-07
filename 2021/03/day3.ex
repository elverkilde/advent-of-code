defmodule Day3 do
  def input do
	File.stream!("input.txt")
	|> Enum.map(&parse/1)
  end

  def parse line do
	line
	|> String.trim
	|> String.graphemes
	|> Enum.map(&String.to_integer/1)
  end

  def transpose rows do
	rows
	|> List.zip
	|> Enum.map(&Tuple.to_list/1)
  end

  def example do
	["00100",
	 "11110",
	 "10110",
	 "10111",
	 "10101",
	 "01111",
	 "00111",
	 "11100",
	 "10000",
	 "11001",
	 "00010",
	 "01010"
	]
  end

  def common row do
	if length(row) / 2 - Enum.sum(row) <= 0 do 1 else 0 end
  end
	
  def gamma rows do
	rows
	|> transpose
	|> Enum.map(&common/1)
  end

  def int_not i do
	if i == 0 do 1 else 0 end
  end
  
  def epsilon rows do
	rows
	|> gamma
	|> Enum.map(&int_not/1)
  end
  
  def decimal binary do
	binary
	|> Enum.reverse
	|> Enum.reduce({0,0}, fn x, {exp, acc} -> {exp+1, acc + x * :math.pow(2,exp)} end)
	|> elem(1)
	|> then(&trunc/1)
  end

  def part1 x do
	decimal(gamma(x)) * decimal(epsilon(x))
  end

  def oxygen(rows) do
	calculate(rows, rows, &common/1)
  end

  def scrubber(rows) do
	calculate(rows, rows, fn x -> int_not(common(x)) end)
  end
  
  def calculate(rows, criteria, f) do
	{hd, tail} = criteria
	|> Enum.map(fn [hd | tail] -> {hd, tail} end)
	|> Enum.unzip

	keep = f.(hd)

	{new_criteria, selected} =
	Enum.zip(hd, Enum.zip(tail, rows))
	|> Enum.filter(fn {criteria, _}  -> criteria == keep end)
	|> Enum.unzip
	|> elem(1)
	|> Enum.unzip
	
	if length(selected) <= 1 do
	  selected
	  |> Enum.map(&decimal/1)
	  |> Enum.sum
	else
	  calculate(selected, new_criteria, f)
	end
  end	
  
  def part2 x do
	oxygen(x) * scrubber(x)
  end
end
