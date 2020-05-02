defmodule PhrasingWeb.Schema do
  use Absinthe.Schema

  @items %{
    "foo" => %{id: "foo", name: "Foo"},
    "bar" => %{id: "bar", name: "Bar"}
  }

  object :item do
    field :id, :id
    field :name, :string
  end

  query do
    field :item, :item do
      arg :id, non_null(:id)
      resolve fn %{id: id}, _ ->
        {:ok, @items[id]}
      end
    end
  end
end
