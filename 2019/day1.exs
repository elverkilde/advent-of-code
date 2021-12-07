defmodule Day1 do
  def required_fuel(mass) do
    floor(mass/3)-2
  end

  def total_fuel(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.to_integer(line) end)
    |> Enum.map(fn n -> adjusted_fuel(0, n) end)
    |> Enum.sum()
  end

  def adjusted_fuel(acc, mass) do
    fuel = required_fuel(mass)
    if fuel > 0 do
      adjusted_fuel(acc+fuel, fuel)
    else
      acc
    end
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()
    
    defmodule Day1Test do
      use ExUnit.Case
      
      test "calculates required fuel" do
	assert Day1.required_fuel(12) == 2
	assert Day1.required_fuel(14) == 2
	assert Day1.required_fuel(1969) == 654
	assert Day1.required_fuel(100756) == 33583
      end
      
      test "calculates fuel from file" do
	assert Day1.total_fuel("""
	12
	14
	1969
	100756
	""") === (2+2+654+33583)
      end

      test "calculates adjusted fuel" do
	assert Day1.adjusted_fuel(0,14) == 2
	assert Day1.adjusted_fuel(0,1969) == 966
	assert Day1.adjusted_fuel(0,100756) == 50346
      end
    end

  [input_file] ->
    input_file
    |> File.read!()
    |> Day1.total_fuel()
    |> IO.puts

  _ ->
    System.halt(1)
end
