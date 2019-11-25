defmodule Phrasing.Dict.Phrase do
  use Ecto.Schema
  import Ecto.Changeset

  @languages [
    [key: "Croatian", value: "hr"],
    [key: "Dutch", value: "nl"],
    [key: "English", value: "en"],
    [key: "French", value: "fr"],
    [key: "Greek", value: "el"],
    [key: "Hindi", value: "hi"],
    [key: "Italian", value: "it"],
    [key: "Japanese", value: "jp"],
    [key: "Russian", value: "ru"],
    [key: "Spanish", value: "sp"],
  ]

  schema "phrases" do
    field :active, :boolean
    field :translations, {:map, :string}
    field :lang, :string
    has_one :card, Phrasing.SRS.Card
    has_one :entry, Phrasing.Dict.Entry


    timestamps()
  end

  @doc false
  def changeset(phrase, attrs) do
    phrase
    |> cast(attrs, [:translations, :lang, :active])
    |> cast_assoc(:card)
    |> validate_required([:translations, :lang])
  end

  def languages, do: @languages
end
