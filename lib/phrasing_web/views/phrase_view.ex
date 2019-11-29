defmodule PhrasingWeb.PhraseView do
  use PhrasingWeb, :view

  alias Ecto.Changeset
  alias Phrasing.Dict.Phrase

  def get_field(changeset, field, default \\ nil) do
    Changeset.get_field(changeset, field, default)
  end
end
