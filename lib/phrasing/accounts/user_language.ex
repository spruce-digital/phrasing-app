defmodule Phrasing.Accounts.UserLanguage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_languages" do
    field :level, :integer

    belongs_to :language, Phrasing.Dict.Language
    belongs_to :user, Phrasing.Dict.User

    timestamps()
  end

  @doc false
  def changeset(user_language, attrs) do
    user_language
    |> cast(attrs, [:level])
    |> validate_required([:level])
  end
end
