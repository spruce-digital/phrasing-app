defmodule Phrasing.Account.UserLanguage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_languages" do
    field :level, :integer

    belongs_to :language, Phrasing.Dict.Language
    belongs_to :user, Phrasing.Dict.User

    timestamps()
  end

  @doc false
  def changeset(user_language, %__MODULE__{} = attrs) do
    __MODULE__.changeset(user_language, Map.from_struct(attrs))
  end

  def changeset(user_language, attrs) do
    user_language
    |> cast(attrs, [:user_id, :language_id, :level])
    |> validate_required([:user_id, :language_id, :level])
  end
end
