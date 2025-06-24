defmodule Test.Text.ParseUpToTest do
  use ExUnit.Case
  import ExAequoBase.Text

  @delim "-->"
  describe "without the delimiter" do
    test "empty input" do
      assert parse_up_to("", @delim) == nil
    end
    test "no match" do
      assert parse_up_to("alpha", @delim) == nil
    end
    test "match immediately, empty rest" do
      assert parse_up_to(@delim, @delim) == {"", ""} 
    end
    test "match immediately, some rest" do
      assert parse_up_to(@delim<>" rest", @delim) == {"", " rest"} 
    end
    test "match later, empty rest" do
      assert parse_up_to("hello" <> @delim, @delim) == {"hello", ""} 
    end
    test "match later, some rest" do
      assert parse_up_to("hello" <> @delim<>" rest", @delim) == {"hello", " rest"} 
    end
  end
  describe "include the delimiter" do
    test "empty input" do
      assert parse_up_to("", @delim, :include) == nil
    end
    test "no match" do
      assert parse_up_to("alpha", @delim, :include) == nil
    end
    test "match immediately, empty rest" do
      assert parse_up_to(@delim, @delim, :include) == {@delim, ""} 
    end
    test "match immediately, some rest" do
      assert parse_up_to(@delim<>" rest", @delim, :include) == {@delim, " rest"} 
    end
    test "match later, empty rest" do
      assert parse_up_to("hello" <> @delim, @delim, :include) == {"hello" <> @delim, ""} 
    end
    test "match later, some rest" do
      assert parse_up_to("hello" <> @delim<>" rest", @delim, :include) == {"hello" <> @delim, " rest"} 
    end
  end
  describe "keep the delimiter" do
    test "empty input" do
      assert parse_up_to("", @delim, :keep) == nil
    end
    test "no match" do
      assert parse_up_to("alpha", @delim, :keep) == nil
    end
    test "match immediately, empty rest" do
      assert parse_up_to(@delim, @delim, :keep) == {"", @delim} 
    end
    test "match immediately, some rest" do
      assert parse_up_to(@delim<>" rest", @delim, :keep) == {"", @delim <> " rest"}
    end
    test "match later, empty rest" do
      assert parse_up_to("hello" <> @delim, @delim, :keep) == {"hello", @delim} 
    end
    test "match later, some rest" do
      assert parse_up_to("hello" <> @delim<>" rest", @delim, :keep) == {"hello",  @delim <> " rest"} 
    end
  end

  defp digits, do: ~r/\d+/
  describe "regex delimiters" do
    test "no match" do
      assert parse_up_to("", digits()) == nil
    end
    test "do not keep or include" do
      assert parse_up_to("a9b", digits()) == {"a", "b"}  
    end
    test "include" do
      assert parse_up_to("a90b", digits(), :include) == {"a90", "b"}  
    end
    test "keep" do
      assert parse_up_to("a90b", digits(), :keep) == {"a", "90b"}  
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
