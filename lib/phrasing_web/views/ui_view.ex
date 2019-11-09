defmodule PhrasingWeb.UIView do
  use PhrasingWeb, :view
  import Ecto.Changeset, only: [get_field: 3, get_field: 2]

  alias Phrasing.Dict

  def language_options(form, field) do
    value = get_field form.source, field
    prompt = [key: "Select language", value: "", selected: is_nil(value), disabled: true]
    [prompt | Dict.Phrase.languages]
  end
end
