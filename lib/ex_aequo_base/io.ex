defmodule ExAequoBase.Io do
  use ExAequoBase.Types
  @moduledoc ~S"""
  Transform input from files, stdin, or binaries
  """

  @line_break ~r/\n\r?/u
  @spec numbered_lines(input_source_t(), natural()) :: numbered_lines_t()
  def numbered_lines(input, initial_lnb \\ 1) do
    numbered_lines_stream(input, initial_lnb)
    |> Enum.into([]) 
  end

  @spec numbered_lines_stream(input_source_t(), natural()) :: Enumerable.t()
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

  @spec _numbered_from_stream(stream_t(), natural()) :: Enumerable.t()
  defp _numbered_from_stream(stream, initial_lnb) do
    stream
    |> Stream.map(fn line -> Regex.replace(@line_break, line, "") end) 
    |> _zip_with_numbers(initial_lnb) 
  end

  @spec _zip_with_numbers(Enumerable.t(), integer()) :: Enumerable.t()
  defp _zip_with_numbers(list, initial_lnb) do
    list 
    |> Stream.zip(Stream.iterate(initial_lnb, &(&1 + 1))) 
  end
      
end
# SPDX-License-Identifier: AGPL-3.0-or-later
