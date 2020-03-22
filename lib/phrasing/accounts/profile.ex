defmodule Phrasing.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :birthday, :date
    field :gender, :string
    field :name, :string

    belongs_to :user, Phrasing.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:birthday, :gender, :name])
  end
end
