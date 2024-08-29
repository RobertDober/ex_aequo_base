defmodule ExAequoBase.Map do
  use ExAequoBase.Types

  @moduledoc ~S"""
  Map helpers
  """

  @doc ~S"""
  put_if is putting values into a map only if a certain value exists

      iex(1)> put_if(%{a: 1}, true, [a: 2, b: 3])
      %{a: 2, b: 3}

  keys can be of any type

      iex(2)> put_if(%{}, true, [{"a", 42}])
      %{"a" => 42}

  But false values return an unchanged map

      iex(3)> put_if(%{a: 1}, false, [a: 2, b: 3])
      %{a: 1}

  """
  @spec put_if(map(), any(), pairs_t()) :: map()
  def put_if(map, value, pairs) do
    if value do
      pairs
      |> Enum.reduce(map, fn {k, v}, result ->
        Map.put(result, k, v)
      end)
    else
      map
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
