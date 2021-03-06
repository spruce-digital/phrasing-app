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
    field :code, :string
  end

  object :phrase do
    field :id, :id
    field :translations, list_of(:translation), resolve: dataloader(Phrasing.Dict)
  end

  input_object :phrase_input do
    field :translations, list_of(:translation_input)
  end

  object :translation do
    field :id, :id
    field :text, :string
    field :language, :language, resolve: dataloader(Phrasing.Dict)
    field :phrase, :phrase, resolve: dataloader(Phrasing.Dict)
  end

  input_object :translation_input do
    field :text, :string
    field :language_id, :id
    field :code, :string
  end

  object :user do
    field :id, :id
    field :email, :string
  end

  object :session do
    field :token, :string
    field :user, :user
  end

  input_object :session_input do
    field :email, :string
    field :password, :string
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

    field :phrase, :phrase do
      arg :id, non_null(:id)
      resolve fn %{id: id}, _ ->
        {:ok, Dict.get_phrase!(id)}
      end
    end

    field :phrases, list_of(:phrase) do
      resolve fn
        _, %{context: %{current_user: current_user}} ->
          {:ok, Dict.list_phrases(user_id: current_user.id)}
        _, _ ->
          {:ok, []}
      end
    end

    field :languages, list_of(:language) do
      resolve fn _, _ ->
        {:ok, Dict.list_languages()}
      end
    end
  end

  mutation do
    field :sign_up, :session do
      arg :input, non_null(:session_input)

      resolve fn _, %{input: input}, _ ->
        with {:ok, user} <- Phrasing.Account.create_user(input),
             {:ok, token, _} <- Phrasing.Guardian.encode_and_sign(user),
             {:ok, _} <- Phrasing.Account.create_jwt(%{user_id: user.id, token: token}) do
          {:ok, %{token: token, user: user}}
        end
      end
    end

    field :sign_in, :session do
      arg :input, non_null(:session_input)

      resolve fn _, %{input: input}, _ ->
        with user <- Phrasing.Account.get_by_email(input[:email]),
             {:ok, user} <- Bcrypt.check_pass(user, input[:password]),
             {:ok, token, _} <- Phrasing.Guardian.encode_and_sign(user),
             {:ok, _} <- Phrasing.Account.create_jwt(%{user_id: user.id, token: token}) do
          {:ok, %{token: token, user: user}}
        end
      end
    end

    field :create_phrase, :phrase do
      arg :input, non_null(:phrase_input)

      resolve fn %{input: input}, %{context: %{current_user: current_user}} ->
        languages = Dict.list_languages()

        IO.inspect(input, label: :create_phrase_input)

        input
        |> Map.put(:user_id, current_user.id)
        |> Map.update(:translations, %{}, fn trs ->
          Enum.map(trs, fn tr ->
            language = Enum.find(languages, fn l -> l.code == tr[:code] end)
            Map.put(tr, :language_id, language.id)
          end)
        end)
        |> Dict.create_phrase()
      end
    end
  end
end
