defmodule PhrasingWeb.PhraseView do
  use PhrasingWeb, :view

  alias Ecto.Changeset

  def get_field(changeset, field, default \\ nil) do
    Changeset.get_field(changeset, field, default)
  end
end
