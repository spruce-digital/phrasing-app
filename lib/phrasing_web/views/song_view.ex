defmodule PhrasingWeb.SongView do
  use PhrasingWeb, :view
  import Ecto.Changeset, only: [get_field: 3]
  import PhrasingWeb.UIView, only: [multi_language_input: 3]

  def label_lang(form, field, lang) do
    id = "song_#{field}_#{lang}"
    name = "language_name(lang)"

    label form, field, for: id do
      name
    end
  end

  def textarea_lang(form, field, lang) do
    id = "song_#{field}_#{lang}"
    name = "song[#{field}][#{lang}]"
    value = get_field(form.source, field, %{})[lang]

    textarea form, field, id: id, name: name, value: value
  end
end
