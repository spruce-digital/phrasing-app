defmodule PhrasingWeb.SongView do
  use PhrasingWeb, :view
  import Ecto.Changeset, only: [get_field: 3]
  import Phrasing.Dict, only: [language_name: 1]

  def label_lang(form, field, lang) do
    id = "song_#{field}_#{lang}"
    name = language_name(lang)

    IO.puts id
    IO.puts name

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
