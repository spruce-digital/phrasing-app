defmodule Phrasing.Accounts.Form do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    # Accounts.User
    field :email, :string

    # Accounts.Profile
    field :birthday, :date
    field :gender, :string
    field :name, :string

    # Accounts.UserLanguage
    field :native_languages, {:array, :string}
    field :learning_languages, {:array, :string}
  end

  @allowed_fields [:email, :birthday, :gender, :name, :native_languages, :learning_languages]

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, @allowed_fields)
  end
end
