defmodule Ema.RecipeTest do
  use ExUnit.Case, async: true
  alias Ema.Recipe

  describe "run/1" do
    defmodule Greet do
      use Ema.Service

      type :name do
        name :string
      end

      type :message do
        text :string
      end

      action :greet, :name, :message, %{"name" => name} do
        {:ok, %{"text" => "Hello #{name}!"}}
      end

      action :get_name, nil, :name do
        {:ok, %{"name" => "Steve"}}
      end

      action :fail, nil, :message do
        {:error, "Oh dear oh dear"}
      end
    end

    test "can run a simple recipe" do
      recipe = %Recipe{
        steps: [
          {Greet, :greet, %{"name" => "Dolly"}}
        ]
      }

      {:ok, result} = Recipe.run(recipe, %{})
      assert result.state == %{"text" => "Hello Dolly!"}
    end

    test "expands template" do
      recipe = %Recipe{
        steps: [
          {Greet, :greet, %{"name" => "{{first_name}} {{last_name}}"}}
        ]
      }

      {:ok, result} = Recipe.run(recipe, %{"first_name" => "Sally", "last_name" => "Smith"})
      assert %{"text" => "Hello Sally Smith!"} = result.state
    end

    test "can use result of previous step" do
      recipe = %Recipe{
        steps: [
          {Greet, :get_name, %{}},
          {Greet, :greet, %{"name" => "{{name}}"}}
        ]
      }

      {:ok, result} = Recipe.run(recipe)
      assert %{"text" => "Hello Steve!"} = result.state
    end

    test "raises if variable not found" do
      recipe = %Recipe{
        steps: [
          {Greet, :greet, %{"name" => "{{name}}"}}
        ]
      }

      assert_raise RuntimeError, ~r"name", fn ->
        Recipe.run(recipe, %{})
      end
    end

    test "can handle when service returns an error" do
      recipe = %Recipe{
        steps: [
          {Greet, :fail, %{}}
        ]
      }

      assert {:error, "Oh dear oh dear"} == Recipe.run(recipe)
    end
  end
end
