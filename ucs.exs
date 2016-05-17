defmodule UniformCostSearch do
  @moduledoc """
  The Uniform Cost Search Is a search Technique that is used to determine what
  action would have the least amount of path cost. It is alot like the Breadth
  First Search algorithm, only It differs in when the goal test is applied.
  This module will illustrate an example of how it can be used in the real world.
  It accompanies the Uniform Cost Search blog post on http://automatingthefuture.com
  """
  @investment_file "data/investment/options.txt"

  def fetch_projections  do
    start_possible_investments_list
    data = File.read!(@investment_file)
    data
    |> String.rstrip(?\n)
    |> String.split("\n")
    |> Enum.each(&gather(&1))
    IO.inspect(Agent.get(PossibleInvestments, &(&1)))
  end

  defp gather(investment) do
    data_list = String.split(investment, ",")
    {company, price} = {List.first(data_list), String.lstrip(List.last(data_list))}
    build_possible_investments(company, price)
  end

  defp start_possible_investments_list do
    Agent.start(fn -> [] end, [name: PossibleInvestments])
  end

  defp build_possible_investments(company, price) do
    data = [company_name: company, projected_price: String.to_float(price)]
    Agent.update(PossibleInvestments, fn(list) -> [data | list] end)
  end
end


UniformCostSearch.fetch_projections
