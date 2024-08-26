defmodule Test.Io.NumberedLinesTest do
  use ExUnit.Case
  import Test.Support.Fixtures
  import ExAequoBase.Io

  describe "empty numbered_lines" do
    test "from empty file" do
      assert numbered_lines(fixture_stream!("empty")) == []
    end
    test "from empty list" do
      assert numbered_lines([]) == []
    end
    test "from empty string" do
      assert numbered_lines("") == []
    end
  end

  describe "some lines" do
    test "from file" do
      expected =
        [
          {"alpha", 1},
          {"beta", 2},
          {"gamma", 3},
        ]
        result = numbered_lines(fixture_stream!("three_lines"))
      assert result == expected
    end
    test "from string" do
      expected =
        [
          {"a", 2}, {"b", 3}
        ]
      result = numbered_lines("a\nb", 2)
      assert result == expected
    end
    test "from lines" do
      expected =
        [
          {"a", 2}, {"b", 3}
        ]
      result = numbered_lines(~W[a b], 2)
      assert result == expected
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
