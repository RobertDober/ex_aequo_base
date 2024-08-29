defmodule ExAequoBase.Types do
  @moduledoc ~S"""
  A collection of types, not limitted to this project BTW.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      @type atoms :: list(atom())

      @type binaries :: list(binary())

      @type either(lt, rt) :: ok_t(lt) | error_t(rt) 
      @type error_t(t) :: {:error, t}
      @type error_t :: {:error, binary()}

      @type input_source_t :: Enumerable.t() | binary() | binaries()

      @type maybe(t) :: nil | t

      @type natural :: non_neg_integer()
      @type numbered(t) :: {t, number()}
      @type numbered_line_t :: numbered(binary())
      @type numbered_lines_t :: list(numbered_line_t())

      @type ok_t(t) :: {:ok, t}
      @type ok_t :: {:ok, any()}

      @type reducer_result_t :: {:halt, error_t()} | {:cont, ok_t()}
      @type result_fun_t() :: ((any) -> result_t())
      @type result_fun_t(t) :: ((any) -> result_t(t))
      @type result_t :: either(any(), binary())
      @type result_t(t) :: either(t, binary())

      @type stream_t :: %IO.Stream{} | %File.Stream{}
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
