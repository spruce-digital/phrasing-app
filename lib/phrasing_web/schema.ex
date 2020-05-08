defmodule PhrasingWeb.Schema.Types do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :item do
    field :id, :id
    field :name, :string
  end

  object :language do
    field :id, :id
    field :name, :string
  end

  object :phrase do
    field :id, :id
    field :translations, list_of(:translation), resolve: dataloader(Phrasing.Dict)
  end

  object :translation do
    field :id, :id
    field :text, :string
    field :language, :language, resolve: dataloader(Phrasing.Dict)
    field :phrase, :phrase, resolve: dataloader(Phrasing.Dict)
  end
end

defmodule PhrasingWeb.Schema do
  use Absinthe.Schema

  alias Phrasing.Dict

  import_types PhrasingWeb.Schema.Types

  @mock_items %{
    "foo" => %{id: "foo", name: "Foo"},
    "bar" => %{id: "bar", name: "Bar"}
  }

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Dict, Dict.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    field :item, :item do
      arg :id, non_null(:id)
      resolve fn %{id: id}, _ ->
        {:ok, @mock_items[id]}
      end
    end

    field :items, list_of(:item) do
      resolve fn _,_ ->
        {:ok, Map.values(@mock_items)}
      end
    end

    field :translations, list_of(:translation) do
      arg :query, :string
      resolve fn
        _, %{query: query}, _ ->
          {:ok, Dict.list_translations(query)}
        _, _, _ ->
          {:ok, Dict.list_translations()}
      end
    end
  end
end
