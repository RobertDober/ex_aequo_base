defmodule ExAequoBase.Text do
  use ExAequoBase.Types
  @moduledoc ~S"""
  Text based tools
  """

  @doc ~S"""
  Removes a prefix (only if matching), or a given count of graphemes from
  the front of a string

      iex(1)> behead("abc", "a")
      "bc"

      
      iex(2)> behead("abc", 2)
      "c"

      iex(3)> behead("abc", 0)
      "abc"

  But 

      iex(4)> assert_raise(
      ...(4)>   ExAequoBase.Text.Error,
      ...(4)>   fn -> behead("abc", "b")
      ...(4)> end)
      

      iex(5)> assert_raise(
      ...(5)>   FunctionClauseError,
      ...(5)>   fn -> behead("abc", -1)
      ...(5)> end)

  """
  @spec behead(binary(), binary() | natural()) :: binary()
  def behead(string, by_string_or_length)
  def behead(string, by) when is_binary(by) do
    if String.starts_with?(string, by) do
      String.slice(string, String.length(by)..-1//1)
    else
      raise ExAequoBase.Text.Error, "must not remove missmatched prefix #{by} from #{string}"
    end
  end
  def behead(string, by) when is_integer(by) and by >= 0 do
    String.slice(string, by..-1//1)
  end

  @doc ~S"""
    Parses an input string up to a given string, returnig prefix and suffix

      iex(6)> parse_up_to("hello world", " ")
      {"hello", "world"}

    We can also use regular expressions

      iex(7)> parse_up_to("hello  world", ~r/\s+/)
      {"hello", "world"}

    We can decide to keep the string we parse up to

      iex(8)> parse_up_to("hello  world", ~r/\s+/, :keep)
      {"hello", "  world"}

    Or to include it into the macth

      iex(9)> parse_up_to("hello  world", ~r/\s+/, :include)
      {"hello  ", "world"}

    If no match nil is returned

      iex(10)> parse_up_to("hi there", ~r/\d+/)
      nil

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
