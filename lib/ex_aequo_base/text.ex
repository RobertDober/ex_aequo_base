defmodule ExAequoBase.Text do
  use ExAequoBase.Types
  @moduledoc ~S"""
  Text based tools
  """

  @spec parse_up_to(binary(), binary(), boolean()) :: result_t(binary()|list(binary()))
  def parse_up_to(input, delim, include_delim \\ false) do
    rgx = Regex.compile!("(.*?)#{Regex.escape(delim)}")
    case Regex.run(rgx, input) do
      nil -> {:error, "cannot parse up to #{delim}"}
      [_, prefix]=match -> 
        result = if include_delim, do: match, else: prefix
        {:ok, result}
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
