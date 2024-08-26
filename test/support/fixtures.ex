defmodule Test.Support.Fixtures do
  @moduledoc ~S"""
  This is to easily access files from the fixtures directory
  """

  def absolute_path(path) do
    Path.join(Path.dirname(Path.dirname(__ENV__.file)), "fixtures/#{path}")
  end

  def fixture_stream!(path) do
    path
    |>absolute_path() 
    |>File.stream! 
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
