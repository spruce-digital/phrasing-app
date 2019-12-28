defmodule Phrasing.Dict.Translation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "translations" do
    field :source, :boolean, default: false
    field :text, :string
    field :script, :string, default: "latin"
    belongs_to :language, Phrasing.Dict.Language
    belongs_to :phrase, Phrasing.Dict.Phrase

    timestamps()
  end

  @doc false
  def changeset(translation, attrs) do
    translation
    |> cast(attrs, [:text, :source, :language_id, :phrase_id])
    |> validate_required([:text, :source, :language_id, :phrase_id])
  end

  def is_empty?(translation) do
    translation.text == nil && translation.language_id == nil
  end
end
