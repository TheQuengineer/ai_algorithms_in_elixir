defmodule NeuralNetwork do
  @moduledoc """
  The Code that illustrates how to calculate the output of a neuron utilizing several
  Transfer functions. What you will see below is the Elixir based implementation
  of these various activation functions. This code accompanies the 2nd post in the
  Artificial Neural Network blog posts on Automating The future called
  `Activating The Artificial Neuron`.
  It also has code present that calculates the errors of a neurons output.
  The local error and the global error formulas can be seen in this file as well.
  """
  defmodule Neuron do
    defstruct [inputs: [], weights: [], bias: nil]
  end

  def calculate_output(:linear, neuron) when is_map(neuron) do
    summation(neuron.inputs, neuron.weights)
    |> add_bias(neuron)
    |> linear
  end

  def calculate_output(:saturating_linear, neuron) when is_map(neuron) do
    summation(neuron.inputs, neuron.weights)
    |> add_bias(neuron)
    |> saturating_linear
  end

  def calculate_output(:symmetric_saturating_linear, neuron) when is_map(neuron) do
    summation(neuron.inputs, neuron.weights)
    |> add_bias(neuron)
    |> symmetric_saturating_linear
  end

  def calculate_output(:hard_limit, neuron) when is_map(neuron) do
    summation(neuron.inputs, neuron.weights)
    |> add_bias(neuron)
    |> hard_limit
  end

  def calculate_output(:positive_linear, neuron) when is_map(neuron) do
    summation(neuron.inputs, neuron.weights)
    |> add_bias(neuron)
    |> positive_linear
  end

  def calculate_output(:sigmoid, neuron) when is_map(neuron) do
    summation(neuron.inputs, neuron.weights)
    |> add_bias(neuron)
    |> sigmoid
  end

  def calculate_output(:symmetrical_hard_limit, neuron) when is_map(neuron) do
    summation(neuron.inputs, neuron.weights)
    |> add_bias(neuron)
    |> symmetrical_hard_limit
  end

  def calculate_output(:hyperbolic_tangent, neuron) when is_map(neuron) do
    summation(neuron.inputs, neuron.weights)
    |> add_bias(neuron)
    |> :math.tanh
  end

  @doc """
    The Linear Error Function used for calculating the error for a single
    Neuron.
  """
  def calculate_local_error(actual, ideal), do: ideal - actual

  @doc """
    The Global Error Function used for calculating the error of the entire
    Neural network.
    `MSE` aka Mean Square Error which is the most commonly used in Neural Networks
  """
  def calculate_global_error(:mse, error_calculations) when is_list(error_calculations) do
    actual =
      Enum.map(error_calculations, &:math.pow(&1, 2))
      |> Enum.sum
    error = actual / length(error_calculations)
    "MSE ERROR: #{error}%"
  end

  @doc """
   The Global Error Function used for calculating the eror of the entire
   Neural Network. This is usually used in the LMA Neural Network Architecture.
   `ESS` is the shortname for Sum of Squares Error.
  """
  def calculate_global_error(:ess, error_calculations) when is_list(error_calculations) do
    errors =
      Enum.map(error_calculations, &:math.pow(&1, 2))
      |> Enum.sum
    total_errors = errors / 2
    "ESS ERROR TOTAL: #{total_errors}"
  end

  def summation([], []), do: 0

  def summation(inputs, weights) when is_list(inputs) and is_list(weights) do
    [i1 | i_tail] = inputs
    [w1 | w_tail] = weights
    (i1 * w1) + summation(i_tail, w_tail)
  end

  def add_bias(calc, neuron), do: calc + neuron.bias

  defp sigmoid(calculation), do: 1 / (1 + :math.exp(-calculation))

  defp positive_linear(calc) when calc < 0 , do: 0

  defp positive_linear(calc) when 0 <= calc, do: calc

  defp hard_limit(calc) when calc < 0, do: 0

  defp hard_limit(calc) when calc >= 0, do: 1

  defp symmetrical_hard_limit(calc) when calc < 0, do: -1

  defp symmetrical_hard_limit(calc) when calc >= 0, do: 1

  defp symmetric_saturating_linear(calc) when calc < -1, do: -1

  defp symmetric_saturating_linear(calc) when -1 <= calc and calc <= 1, do: calc

  defp symmetric_saturating_linear(calc) when calc > 1, do: 1

  defp saturating_linear(calc) when calc < 0, do: 0

  defp saturating_linear(calc) when calc <= 0 and calc <= 1, do: calc

  defp saturating_linear(calc) when calc > 1, do: 1

  defp linear(calc) when is_float(calc), do: calc
end
