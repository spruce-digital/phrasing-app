defmodule Phrasing.Account.JWT do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jwts" do
    field :token, :string

    belongs_to :user, Phrasing.Account.User

    timestamps()
  end

  @doc false
  def changeset(jwt, attrs) do
    jwt
    |> cast(attrs, [:token, :user_id])
    |> validate_required([:token, :user_id])
  end
end
