defmodule Phrasing.Dict.Translation do
  use Ecto.Schema
  use StructAccess
  import Ecto.Changeset

  schema "translations" do
    field :source, :boolean, default: false
    field :text, :string
    field :script, :string, default: "latin"
    field :delete, :boolean, default: false, virtual: true
    field :guid, :integer, virtual: true
    field :line_id, :integer, virtual: true
    belongs_to :language, Phrasing.Dict.Language
    belongs_to :phrase, Phrasing.Dict.Phrase
    has_many :cards, Phrasing.SRS.Card

    timestamps()
  end

  @doc false
  def changeset(translation, attrs) do
    translation
    |> cast(attrs, [:text, :source, :language_id, :phrase_id, :guid])
    |> validate_required([:text, :source, :language_id, :phrase_id])
    |> sweep()
  end

  @doc """
  Used to make sure translations are valid without a phrase_id
  """
  def dry_changeset(translation, attrs) do
    translation
    |> cast(attrs, [:text, :source, :language_id, :phrase_id])
    |> validate_required([:text, :source, :language_id])
    |> sweep()
  end

  def is_empty?(translation) do
    translation.text == nil && translation.language_id == nil
  end

  def sweep(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
