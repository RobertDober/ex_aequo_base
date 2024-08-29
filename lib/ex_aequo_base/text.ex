defmodule ExAequoBase.Text do
  use ExAequoBase.Types
  @moduledoc ~S"""
  Text based tools
  """

  @doc ~S"""
    Parses an input string up to a given string, returnig prefix and suffix

      iex(1)> parse_up_to("hello world", " ")
      {"hello", "world"}

    We can also use regular expressions

      iex(2)> parse_up_to("hello  world", ~r/\s+/)
      {"hello", "world"}

    We can decide to keep the string we parse up to

      iex(3)> parse_up_to("hello  world", ~r/\s+/, :keep)
      {"hello", "  world"}

    Or to include it into the macth

      iex(4)> parse_up_to("hello  world", ~r/\s+/, :include)
      {"hello  ", "world"}

  """
  @spec parse_up_to(binary(), binary()|Regex.t(), atom()) :: maybe({binary(), binary()})
  def parse_up_to(input, delim, option \\ nil)
  def parse_up_to(input, delim, option) do
    rgx = _mk_rgx(delim)
    case Regex.run(rgx, input) do
      nil -> nil
      [_, prefix, delim_match, rest] -> _return_match(prefix, delim_match, rest, option) 
    end
  end

  @spec _mk_rgx(binary() | Regex.t) :: Regex.t
  defp _mk_rgx(source)
  defp _mk_rgx(string) when is_binary(string) do
    Regex.compile!("\\A(.*?)(#{Regex.escape(string)})(.*)")
  end
  defp _mk_rgx(rgx) do
    Regex.compile!("\\A(.*?)(#{Regex.source(rgx)})(.*)")
  end

  @spec _return_match(binary(), binary(), binary(), atom()) :: {binary(), binary()}
  defp _return_match(prefix, delim_match, rest, option)
  defp _return_match(prefix, _delim_match, rest, nil), do: {prefix, rest}
  defp _return_match(prefix, delim_match, rest, :include), do: {prefix <> delim_match, rest}
  defp _return_match(prefix, delim_match, rest, :keep), do: {prefix, delim_match <> rest}

end
# SPDX-License-Identifier: AGPL-3.0-or-later
