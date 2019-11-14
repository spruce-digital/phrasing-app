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
    field :literal, :string
    field :source, :string
    field :source_lang, :string
    field :translation, :string
    field :translation_lang, :string
    field :translit, :string
    has_one :card, Phrasing.SRS.Card


    timestamps()
  end

  @doc false
  def changeset(phrase, attrs) do
    phrase
    |> cast(attrs, [:source, :source_lang, :translation, :translation_lang, :literal, :translit])
    |> cast_assoc(:card)
    |> validate_required([:source, :source_lang, :translation, :translation_lang])
  end

  def languages, do: @languages
end
