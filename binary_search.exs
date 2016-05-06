defmodule BinarySearch do
  @moduledoc """
  The easiest search algorithm in computer science. This particular implementation
  Works with a flat text file that is in the data/ directory of this project.
  The entry point is the `find_in/2` function. This module accompanies the third blog
  post about binary searching in elixir on http://automatingthefuture.com.
  """

  def find_in(file, target) when is_bitstring(file) and is_integer(target) do
    {:ok, data} = File.read(file)
    IO.puts("Searching for #{target} in file #{file}")
    data
    |> prepare
    |> Enum.sort(&(&1 < &2))
    |> divide_and_conquer_for(target)
    |> show_results
  end

  defp divide_and_conquer_for(list, target) when is_list(list) do
    highest_boundry = length(list) - 1
    lowest_boundry = 0
    reduce_search(list, target, lowest_boundry, highest_boundry)
  end

  defp reduce_search(list, target, lowest_boundry, highest_boundry) do
    middleIndex = div(highest_boundry + lowest_boundry, 2)
    middleValue = Enum.at(list, middleIndex, "Ouch.. Nothing here!")

    cond do
      highest_boundry < lowest_boundry  -> "Number not found."
      target < middleValue -> reduce_search(list, target, lowest_boundry, middleIndex - 1)
      target > middleValue -> reduce_search(list, target, middleIndex + 1, highest_boundry)
      target == middleValue -> middleValue
    end
  end

  defp show_results("Number not found.") do
    IO.puts("#{"\u274C"}  Nope. That number is not in file")
  end

  defp show_results(target) do
    IO.puts("#{"\u2705"}  Yes, Number #{target} is present in file.")
  end

  defp prepare(data) do
    list = String.replace(data, "\n", " ")
    str_numbers_list = Regex.scan(~r/\d+/, list)
    str_numbers_list
    |> List.flatten
    |> Enum.map(&String.to_integer(&1))
  end
end

BinarySearch.find_in("data/file_of_numbers.txt", 777)
