defmodule GenerateAndTest do
  @moduledoc """
  This script is designed to show the functionality of the AI Algorithm
  that is known as Generate and Test. It will produce the results to a
  addition question and answer whether or not the answer is even.
  """

  def start do
    start_list
    generate(20)
    Enum.each(questions, &display_answer_for(&1))
  end

  defp display_answer_for(question) do
    IO.puts(question)
    IO.puts(answer_to(question))
  end

  defp answer_to(question) do
    Regex.scan(~r/(\d+) \+ (\d+)/, question, [capture: :all_but_first])
    |> List.flatten
    |> Enum.map(&String.to_integer(&1))
    |> Enum.reduce(0, fn(n, acc) -> n + acc end)
    |> even?
    |> say_answer
  end

  defp addition_question(first_number, second_number) do
    "Is the result of #{first_number} + #{second_number} even?"
  end

  defp even?(number) when is_number(number) do
    if rem(number, 2) == 0, do: true, else: false
  end

  defp say_answer(true) do
    "YES!"
  end

  defp say_answer(false) do
    "NOPE."
  end

  def start_list do
    Agent.start(fn() -> [] end, [name: __MODULE__])
  end

  defp build_list(question) do
    Agent.update(__MODULE__, fn(list) -> [question | list] end)
  end

  def questions do
    Agent.get(__MODULE__, &(&1))
  end

  def generate(amount_of_questions) when is_number(amount_of_questions) do
    generate(0, amount_of_questions)
  end

  def generate(accumulator, amount_of_questions) when amount_of_questions >= 1 do
    question = addition_question(Enum.random(1..100_000), Enum.random(1..100_000))
    build_list(question)
    generate(accumulator + 1, amount_of_questions - 1)
  end

  def generate(total, 0) do
    IO.puts("#{total} addition questions generated.")
    :ok
  end
end

GenerateAndTest.start
