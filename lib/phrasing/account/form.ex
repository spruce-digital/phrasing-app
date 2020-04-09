defmodule Phrasing.Account.Form do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    # Account.User
    field :email, :string

    # Account.Profile
    field :birthday, :date
    field :gender, :string
    field :name, :string

    # Account.UserLanguage
    field :native_languages, {:array, :string}, default: []
    field :learning_languages, {:array, :string}, default: []
  end

  @allowed_fields [:email, :birthday, :gender, :name, :native_languages, :learning_languages]

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, @allowed_fields)
  end
end
