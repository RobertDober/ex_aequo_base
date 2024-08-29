defmodule ExAequoBase.Io do
  use ExAequoBase.Types
  @moduledoc ~S"""
  Transform input from files, stdin, or binaries
  """

  @line_break ~r/\n\r?/u

  @doc ~S"""

    From an enumerable of lines, create a list of tuples containing lines and line_numbers

      iex(1)> numbered_lines(~W[a b c])
      [{"a", 1}, {"b", 2}, {"c", 3}]  

    You can start with any number you want

      iex(2)> numbered_lines(~W[a b c], -1.5)
      [{"a", -1.5}, {"b", -0.5}, {"c", 0.5}]  

    Why is this in a module called `Io`?

      iex(3)> numbered_lines(fixture_stream!("three_lines"), 2)
      [{"alpha", 2}, {"beta", 3}, {"gamma", 4}]  

  """
  @spec numbered_lines(input_source_t(), number()) :: numbered_lines_t()
  def numbered_lines(input, initial_lnb \\ 1) do
    numbered_lines_stream(input, initial_lnb)
    |> Enum.into([]) 
  end

  @doc ~S"""
  Same as `numbered_lines` but just returning a stream

      iex(4)> s = numbered_lines_stream(~W[x y])
      ...(4)> assert is_function(s)
      ...(4)> s |> Enum.into([])
      [{"x", 1}, {"y", 2}]

  """
  @spec numbered_lines_stream(input_source_t(), number()) :: Enumerable.t()
  def numbered_lines_stream(input_source, initial_lnb \\ 1) 
  def numbered_lines_stream(list, initial_lnb) when is_list(list) do
    list
    |> _zip_with_numbers(initial_lnb)
  end
  def numbered_lines_stream("", _initial_lnb), do: []
  def numbered_lines_stream(string, initial_lnb) when is_binary(string) do
    string
    |> String.split(@line_break) 
    |> _zip_with_numbers(initial_lnb) 
  end
  def numbered_lines_stream(%File.Stream{}=stream, initial_lnb) do
    _numbered_from_stream(stream, initial_lnb)
  end
  def numbered_lines_stream(%IO.Stream{}=stream, initial_lnb) do
    _numbered_from_stream(stream, initial_lnb)
  end

  @spec _numbered_from_stream(stream_t(), number()) :: Enumerable.t()
  defp _numbered_from_stream(stream, initial_lnb) do
    stream
    |> Stream.map(fn line -> Regex.replace(@line_break, line, "") end) 
    |> _zip_with_numbers(initial_lnb) 
  end

  @spec _zip_with_numbers(Enumerable.t(), number()) :: Enumerable.t()
  defp _zip_with_numbers(list, initial_lnb) do
    list 
    |> Stream.zip(Stream.iterate(initial_lnb, &(&1 + 1))) 
  end
      
end
# SPDX-License-Identifier: AGPL-3.0-or-later
