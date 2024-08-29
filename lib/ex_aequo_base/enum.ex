defmodule ExAequoBase.Enum do
  use ExAequoBase.Types
  @moduledoc ~S"""
  Extensions to `Enum`
  """

  @doc ~S"""
  `map_ok` wrapps `map` around functions that return result types `result_t`

      iex(1)> map_ok(1..2, fn x -> {:ok, x + 1} end)
      {:ok, [2, 3]}

      iex(2)> map_ok(0..2, fn x -> if rem(x, 2) == 0, do: {:ok, x + 1}, else: {:error, "not even even"} end)
      {:error, "not even even"}

  If the mapper function returning nil shall be captured as an error you need to allow this explicitly

      iex(3)> map_ok(0..2, fn x -> if rem(x, 2) == 0, do: {:ok, x} end, true)
      {:error, "mapper function returned nil on 1"}

  but...

      iex(4)> assert_raise(
      ...(4)> CaseClauseError,
      ...(4)>fn -> map_ok(0..2, fn x -> if rem(x, 2) == 0, do: {:ok, x} end) end)

  """
  @spec map_ok(Enumerable.t(), result_fun_t(), boolean()) :: result_t()
  def map_ok(enum, fun, nil_is_error \\ false) do
    mapper = if nil_is_error, do: &_map_ok_and_nil(&1, &2, fun), else: &_map_ok(&1, &2, fun)
    case Enum.reduce_while(enum, [], mapper) do
      {:error, _} = error -> error
      result -> {:ok, Enum.reverse(result)}
    end
  end

  @spec _map_ok(any(), any(), result_fun_t()) :: reducer_result_t()
  defp _map_ok(elem, acc, fun) do
    case fun.(elem) do
      {:error, _} = error -> {:halt, error}
      {:ok, value} -> {:cont, [value|acc]}
    end
  end

  @spec _map_ok_and_nil(any(), any(), result_fun_t()) :: reducer_result_t()
  defp _map_ok_and_nil(elem, acc, fun) do
    case fun.(elem) do
      {:error, _} = error -> {:halt, error}
      nil -> {:halt, {:error, "mapper function returned nil on #{inspect(elem)}"}}
      {:ok, value} -> {:cont, [value|acc]}
    end
  end
   
end
# SPDX-License-Identifier: AGPL-3.0-or-later
