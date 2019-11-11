defmodule PhrasingWeb.UIView do
  use PhrasingWeb, :view
  import Ecto.Changeset, only: [get_field: 3, get_field: 2]
  import Phrasing.Dict, only: [language_name: 1]

  alias Phrasing.Dict

  def language_options(form, field) do
    value = get_field form.source, field
    prompt = [key: "Select language", value: "", selected: is_nil(value), disabled: true]
    [prompt | Dict.Phrase.languages]
  end

  def language_options(form, field, language) do
    prompt = [key: "Select Language", value: "", disabled: true]
    [prompt | Dict.Phrase.languages]
    |> Enum.map(&select_language_option(&1, language))
  end

  def label_lang(form, field, lang) do
    id = "#{form.name}_#{field}_#{lang}"
    name = language_name(lang)

    label form, field, for: id do
      name
    end
  end

  def textarea_lang(form, field, lang) do
    id = "#{form.name}_#{field}_#{lang}"
    name = "#{form.name}[#{field}][#{lang}]"
    value = get_field(form.source, field, %{})[lang]

    textarea form, field, id: id, name: name, value: value
  end

  def select_lang(form, field) do
    select form, field, language_options(form, field)
  end

  def select_lang(form, field, assigns) do
    language = assigns[:language]
    index = assigns[:index]

    if is_nil(language) and is_nil(index) do
      select_lang(form, field)
    else
      id = "#{form.name}_#{field}_#{index}"
      name = "#{form.name}[#{field}][]"

      select form, field, language_options(form, field, language), id: id, name: name
    end
  end

  defp select_language_option(option, lang) do
    cond do
      lang == nil && option[:value] == ""   -> option ++ [selected: true]
      lang != nil && option[:value] == lang -> option ++ [selected: true]
      true -> option
    end
  end
end
