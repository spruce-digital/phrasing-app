defmodule PhrasingWeb.UILive.Field.Translation do
  use Phoenix.LiveComponent

  alias Ecto.Changeset
  alias Phoenix.HTML.Form
  alias Phrasing.Dict
  alias PhrasingWeb.UILive

  @defaults %{
    input_type: :text_input,
    label_prefix: "",
    source: false,
    translation_id: nil
  }

  @empty_language %Dict.Language{
    name: ""
  }

  def mount(_session, socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, Map.merge(@defaults, assigns))}
  end

  def render(assigns) do
    language = get_language_from_assigns(assigns)

    ~L"""
    <div class="language-field" id="<%= @id %>">
      <%= render_label(assigns, language) %>
      <%= render_select(assigns, language) %>
      <%= render_input(assigns, language) %>
    </div>
    """
  end

  def render_label(%{form: form, label_prefix: label_prefix}, language) do
    id = "#{form.name}_translations_#{language.id}"
    name = label_prefix <> language.name

    Form.label(form, :translations, name, for: id)
  end

  def render_select(assigns, language) do
    ~L"""
    <select>
      <%= unless language.id do %>
        <option value="" selected disabled>Select Language</option>
      <% end %>
      <%= for l <- @languages do %>
        <option value="<%= l.id %>" <%= option_selected(l, language) %> <%= option_disabled(l, assigns) %>>
          <%= l.name %>
        </option>
      <% end %>
    </select>
    """
  end

  def render_input(%{form: form, input_type: input_type}, language) do
    id = "#{form.name}_translations_#{language.id}"
    name = "#{form.name}[translations][#{language.id}]"
    value = Changeset.get_field(form.source, :translations, %{})[language.id]

    case input_type do
      :text_input -> Form.text_input(form, :translations, id: id, name: name, value: value)
    end
  end

  def preload(assigns_list) do
    languages = Dict.list_languages()

    Enum.map(assigns_list, fn assigns ->
      Map.put(assigns, :languages, languages)
    end)
  end

  def get_language_from_assigns(%{source: true, languages: languages, form: form}) do
    language_id = Changeset.get_field(form.source, :language_id)
    Enum.find(languages, @empty_language, fn l -> l.id == language_id end)
  end

  def get_language_from_assigns(%{
        translation_id: translation_id,
        languages: languages,
        form: form
      }) do
    translation_id = Changeset.get_field(form.source, :translation_id)
    Enum.find(languages, @empty_language, fn l -> l.id == translation_id end)
  end

  def option_selected(a, b) do
    if a.id == b.id, do: "selected", else: ""
  end

  def option_disabled(language, assigns) do
    source_language_id = Changeset.get_field(assigns.form.source, :language_id)
    is_source = assigns.source

    if language.id == source_language_id and !is_source, do: "disabled", else: ""
  end
end
