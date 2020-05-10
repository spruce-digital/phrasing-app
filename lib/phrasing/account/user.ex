defmodule Phrasing.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :is_admin, :boolean
    field :password, :string, virtual: true

    has_one :profile, Phrasing.Account.Profile, on_replace: :update

    has_many :user_languages, Phrasing.Account.UserLanguage, on_replace: :delete
    has_many :cards, Phrasing.SRS.Card
    has_many :jwts, Phrasing.Account.JWT

    many_to_many :languages, Phrasing.Dict.Language,
      join_through: "user_languages",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :is_admin])
    |> cast_assoc(:profile)
    |> cast_assoc(:user_languages)
    |> unique_constraint(:email, downcase: true)
    |> validate_required([:email])
    |> put_encrypted_password()
  end

  @doc false
  def changeset_signin(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end

  defp put_encrypted_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
