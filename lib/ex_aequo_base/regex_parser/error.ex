defmodule ExAequoBase.RegexParser.Error do
  @moduledoc ~S"""
  Error raised for an unparsable string
  """

  defexception [:message]

  @type t :: %__MODULE__{message: binary()}

  def exception(msg), do: %__MODULE__{message: msg}
end
# SPDX-License-Identifier: AGPL-3.0-or-later
