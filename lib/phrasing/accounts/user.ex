defmodule Phrasing.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    has_one :profile, Phrasing.Accounts.Profile

    has_many :user_languages, Phrasing.Accounts.UserLanguage

    many_to_many :languages, Phrasing.Dict.Language,
      join_through: "user_languages",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password])
    |> cast_assoc(:profile)
    |> cast_assoc(:user_languages)
    |> validate_required([:email, :encrypted_password])
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Bcrypt.hash_pwd_salt/1)
  end

  @doc false
  def changeset_signin(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end
end
