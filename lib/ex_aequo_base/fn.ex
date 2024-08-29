defmodule ExAequoBase.Fn do
  use ExAequoBase.Types
  @moduledoc ~S"""
  Functional Helpers
  """

  @doc ~S"""
  Runs the first function that does not return nil

      iex(1)> fns = [
      ...(1)> fn -> nil end,
      ...(1)> fn -> 42 end,
      ...(1)> fn -> "not reached" end
      ...(1)> ]
      ...(1)> select(fns)
      42
        

  Returns an error if no function matched 

      iex(2)> select([fn -> nil end])
      {:error, "No functions matched"}

  Even if the input was empty

      iex(3)> select([])
      {:error, "No functions matched"}

  """

  @spec select(list(zero_fn_t())) :: any()
  def select(functions)
  def select([]) do
    {:error, "No functions matched"}
  end
  def select([f|fs]) do
    case f.() do
      nil -> select(fs)
      result -> result
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
