defmodule ConcurrentSearch do
  @moduledoc """
  This uses the Binary search algo which is the easiest search algorithm in computer science.
  This particular implementation simultanously searches every player file in the
  data directory for the target supplied by the user. It portrays the scalability
  and flexibility of elixir.

  The entry point is the `find/1` function. This module accompanies the third blog
  post about performing concurrent searches with elixir on http://automatingthefuture.com.
  """

  def find(target) when is_number(target) do
    search_through = fn(file, target) ->
      IO.puts("Searching for #{target} in file #{file}")
      caller = self()
      spawn(fn() ->
        send(caller, {find_in(file, target), file})
      end)
      get_result
    end

    files = fetch_files()

    Enum.each(files, &search_through.(&1, target))
  end

  def find_in(file, target) when is_bitstring(file) and is_integer(target) do
    {:ok, data} = File.read(file)
    data
    |> prepare
    |> Enum.sort(&(&1 < &2))
    |> divide_and_conquer_for(target)
  end

  defp fetch_files do
    Path.wildcard("data/players/*.txt")
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

  defp get_result do
    receive do
      {"Number not found.", file} -> IO.puts "#{"\u274C"}  Nope. that number is not in file #{file}"
      {_, file} -> IO.puts "#{"\u2705"}  Yes, Number is present in file #{file}."
    end
  end

  defp prepare(data) do
    list = String.replace(data, "\n", " ")
    str_numbers_list = Regex.scan(~r/\d+/, list)
    str_numbers_list
    |> List.flatten
    |> Enum.map(&String.to_integer(&1))
  end
end

ConcurrentSearch.find(777)
