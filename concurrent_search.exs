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
    start_results_list
    files = fetch_files()
    IO.puts("Searching for #{target} in all #{IO.inspect(length(files))} files")
    {time, _} = :timer.tc(fn -> search_in(files, target) end)
    IO.inspect(Agent.get(__MODULE__, &(&1)))
    IO.puts("Search completed in #{IO.inspect(time)} MicroSeconds!")
  end

  defp search_in(files, target) do
    current_caller = self
    files
    |> Enum.map(fn(file) ->
      spawn_link(fn() ->
        send(current_caller, {self, find_in(file, target), file})
      end)
    end)
    |> Enum.map(fn(pid) -> get_result_for(pid) end)
  end

  def find_in(file, target) when is_bitstring(file) and is_integer(target) do
    {:ok, data} = File.read(file)
    data
    |> prepare
    |> Enum.sort(&(&1 < &2))
    |> divide_and_conquer_for(target)
  end

  defp fetch_files do
    Path.wildcard("data/people/*.txt")
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

  defp get_result_for(pid) do
    receive do
      {^pid, "Number not found.", file} ->
        response = "#{"\u274C"}  Nope. that number is not in file #{file}"
        Agent.update(__MODULE__, fn(list) -> [response | list] end)
      {^pid, number, file} ->
        response = "#{"\u2705"}  Yes, #{number} is present in file #{file}."
        Agent.update(__MODULE__, fn(list) -> [response | list] end)
    end
  end

  defp prepare(data) do
    list = String.replace(data, "\n", " ")
    str_numbers_list = Regex.scan(~r/\d+/, list)
    str_numbers_list
    |> List.flatten
    |> Enum.map(&String.to_integer(&1))
  end

  defp start_results_list do
    Agent.start(fn() -> [] end, [name: __MODULE__])
  end
end

ConcurrentSearch.find(777)
