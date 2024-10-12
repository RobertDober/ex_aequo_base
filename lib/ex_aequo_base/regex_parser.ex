defmodule ExAequoBase.RegexParser do
  use ExAequoBase.Types

  alias ExAequoFn.NamedFn
  import NamedFn, only: [call: 2, new: 2]
  alias __MODULE__.Error

  @moduledoc ~S"""

  Parses an input string according to a list of regexen and associated actions

      iex(1)> rgxen = [ 
      ...(1)> {~r/\A\s+/, ""}, # ignored, sort of
      ...(1)> {~r/\A\d+/, &String.to_integer/1},
      ...(1)> {~r/\A(,),/, ","},
      ...(1)> {~r/\A(,)/, :comma},
      ...(1)> {~r/\A(.+?)(?=,)/}
      ...(1)> ]
      ...(1)> parse(rgxen, " 42alpha,beta,, , ")
      ["", 42, "alpha", :comma, "beta", ",", "", :comma, ""]

  In case we want to eliminate empty strings immediately we can use the special atom `:ignore`

      iex(2)> rgxen = [ 
      ...(2)> {~r/\A\s+/, :ignore}, # ignored, sort of
      ...(2)> {~r/\A\d+/, &String.to_integer/1},
      ...(2)> {~r/\A(,),/, ","},
      ...(2)> {~r/\A(,)/, :comma},
      ...(2)> {~r/\A(.+?)(?=,)/}
      ...(2)> ]
      ...(2)> parse(rgxen, " 42alpha,beta,, , ")
      [42, "alpha", :comma, "beta", ",", :comma]

  It might be more efficent to tell the parser where the rest is

      iex(3)> parse([{~r/\A(.)(.*)/}], "hello")
      ["h", "e", "l", "l", "o"]

  We can also parse keywords

      iex(4)> parse([{"hell"}, {"o"}], "hello")
      ["hell", "o"]

  But we need to parse all parts of a string

      iex(5)> assert_raise(Error, fn -> parse([{"a"}], "ab") end)


  """

  @type spec_t :: pair_t(binary()|Regex.t(), any())
  @type specs_t :: list(spec_t())
  @spec parse(specs_t(), binary()) :: list()
  def parse(rgxen, input) do
    compiled = _compile(rgxen)
     _parse(compiled, input, [])
  end

  @spec _parse(rgx_pairs(), binary(), list()) :: list()
  defp _parse(rgxen, input, result)
  defp _parse(_, "", result), do: Enum.reverse(result)
  defp _parse(rgxen, input, result) do
    case Enum.find_value(rgxen, _match_on(input)) do
      nil -> raise Error, _mk_message(rgxen, input)
      {:ignore, rest} -> _parse(rgxen, rest, result)
      {ast, rest} -> _parse(rgxen, rest, [ast|result])
    end
  end

  @spec _apply_to_match(binaries(), NamedFn.t(), binary()) :: pair_t(any(), binary())
  defp _apply_to_match(match, action, input) do
    case match do
      [all] ->
        {call(action, all),
          String.slice(input, String.length(all)..-1//1)}
      [all, relevant] -> 
        {call(action, relevant),
          String.slice(input, String.length(all)..-1//1)}
      [_, relevant, rest] -> {call(action, relevant), rest}
    end
  end

  @spec _compile(specs_t()) :: rgx_pairs()
  defp _compile(rgxen) do
    Enum.map(rgxen, &_compile_pair/1)
  end

  @spec _compile_action(any()) :: NamedFn.t()
  defp _compile_action(action)
  defp _compile_action(action) when is_function(action) do
    new(action, inspect(action))
  end
  defp _compile_action(action) do
    new(fn _ -> action end, "constant fn -> #{action}")
  end

  @spec _compile_pair(spec_t()) :: rgx_pair()
  defp _compile_pair({spec, action}) do
    {_compile_spec(spec), _compile_action(action)}
  end

  @spec _compile_pair({Regex.t()|binary()}) :: rgx_pair()
  defp _compile_pair({spec}) do
    _compile_pair({spec, &(&1)})
  end

  @spec _compile_spec(Regex.t()|binary()) :: Regex.t()
  defp _compile_spec(spec)
  defp _compile_spec(spec) when is_binary(spec) do
    Regex.compile!("\\A(#{Regex.escape(spec)})") 
  end
  defp _compile_spec(%Regex{} = spec), do: spec

  @spec _match_on(binary()) :: parser_fn()
  defp _match_on(input) do
    fn {rgx, action} ->
      case Regex.run(rgx, input) do
        nil -> nil
        match -> _apply_to_match(match, action, input)
      end
    end
  end

  @spec _mk_message(rgx_pairs(), binary()) :: binary()
  defp _mk_message(rgxen, input) do
    [
      "Cannot match any of the following rgxen:",
      inspect(rgxen),
      "with input:",
      inspect(input)
    ] |> Enum.join("\n")
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
