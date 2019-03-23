defmodule Lana.Schema do
  use Absinthe.Schema

  alias Lana.Resolvers

  query do
    field :services, list_of(:service) do
      resolve &Resolvers.Service.list_services/3
    end
  end

  mutation do
    field :run_recipe, :boolean do
      resolve &Resolvers.Recipe.run/3
    end
  end

  object :service do
    field :name, :string
    field :description, :string
  end
end
