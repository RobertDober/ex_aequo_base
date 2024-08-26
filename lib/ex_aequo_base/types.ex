defmodule ExAequoBase.Types do
  @moduledoc ~S"""
  A collection of types, not limitted to this project BTW.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      @type binaries :: list(binary())

      @type either(lt, rt) :: {:ok, lt} | {:error, rt}

      @type input_source_t :: Enumerable.t() | binary() | binaries()

      @type maybe(t) :: nil | t

      @type natural :: non_neg_integer()
      @type numbered(t) :: {t, natural()}
      @type numbered_line_t :: numbered(binary())
      @type numbered_lines_t :: list(numbered_line_t())

      @type result_t(t) :: either(t, binary())

      @type stream_t :: %IO.Stream{} | %File.Stream{}
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
