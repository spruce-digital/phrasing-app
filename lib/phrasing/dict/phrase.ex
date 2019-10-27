defmodule Phrasing.Dict.Phrase do
  use Ecto.Schema
  import Ecto.Changeset

  @languages [
    [key: "Croatian", value: "hr"],
    [key: "Dutch", value: "nl"],
    [key: "French", value: "fr"],
    [key: "Greek", value: "el"],
    [key: "Hindi", value: "hi"],
    [key: "Italian", value: "it"],
    [key: "Japanese", value: "jp"],
    [key: "Russian", value: "ru"],
    [key: "Spanish", value: "sp"],
  ]

  @dialects %{
    "nl" => [
      [key: "nl", value: "Netherlands"],
      [key: "be", value: "Belgium"],
    ],
  }

  schema "phrases" do
    field :dialect, :string
    field :english, :string
    field :lang, :string
    field :literal, :string
    field :source, :string
    field :translit, :string
    has_one :card, Phrasing.SRS.Card


    timestamps()
  end

  @doc false
  def changeset(phrase, attrs) do
    phrase
    |> cast(attrs, [:source, :english, :lang, :dialect, :literal, :translit])
    |> validate_required([:source, :english, :lang])
  end

  def languages, do: @languages
  def dialects, do: @dialects
  def dialects(language), do: Access.get @dialects, to_string(language), []
end
