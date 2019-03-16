defmodule Ema.TemplateTest do
  use ExUnit.Case, async: true
  alias Ema.Template

  describe "parse/1 - ok" do
    test "with constant string" do
      t("hello", [str: "hello"])
    end

    test "with an expression" do
      t("hello {{name}}!", [str: "hello ", expr: "name", str: "!"])
    end

    test "with multiple expressions" do
      t("{{name}} is {{status}}", [expr: "name", str: " is ", expr: "status"])
    end

    test "with only expression" do
      t("{{name}}", [expr: "name"])
    end

    test "trims spaces inside expression" do
      t("{{     name     }}", [expr: "name"])
    end

    test "unicode works outside expression" do
      t("こんにちは {{name}}", [str: "こんにちは ", expr: "name"])
    end

    test "can use single brace as part of string" do
      t("{}", [str: "{}"])
    end
  end

  describe "parse/2 - error" do
    test "umatched open double brace" do
      e("{{")
    end

    test "unmatched close brace" do
      e("}}")
    end

    test "non ascii character in expression" do
      e("{{悪い入力}}")
    end

    test "nested braces" do
      e("{{ {{ name }} }}")
    end
  end

  defp t(input_string, desired) do
    assert {:ok, desired} == Template.parse(input_string)
  end

  defp e(input_string) do
    assert {:error, _} = Template.parse(input_string)
  end
end
