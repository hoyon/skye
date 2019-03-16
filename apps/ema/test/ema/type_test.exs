defmodule Ema.TypeTest do
  use ExUnit.Case
  import Ema.Type

  defmodule Service do
    use Ema.Service

    type :post do
      title :string
      author :string
    end
  end

  describe "check_type/3" do
    test "checks type given a service and typename" do
      assert check_type(%{"title" => "some clickbait", "author" => "bob"}, Service, :post)
    end
  end

  describe "check_type/2" do
    test "returns true for correct type" do
      assert check_type(
               %{"title" => "some clickbait", "author" => "bob"},
               Service.__ema_type_post()
             )
    end

    test "returns false with missing fields" do
      refute check_type(%{"title" => "some clickbait"}, Service.__ema_type_post())
    end

    test "returns false with incorrect field type" do
      refute check_type(%{"title" => "some clickbait", "author" => 4}, Service.__ema_type_post())
    end
  end
end
