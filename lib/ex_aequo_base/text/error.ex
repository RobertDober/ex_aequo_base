defmodule ExAequoBase.Text.Error do
  @moduledoc false
  
  defexception [:message]

  @type t :: %__MODULE__{message: binary()}

  @doc false
  def exception(msg), do: %__MODULE__{message: msg}

end
# SPDX-License-Identifier: AGPL-3.0-or-later
