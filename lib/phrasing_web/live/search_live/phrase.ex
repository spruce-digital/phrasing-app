defmodule PhrasingWeb.SearchLive.Phrase do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form
  import Ecto.Changeset

  alias Phrasing.Dict
  alias Phrasing.Dict.{Phrase,Translation}
  alias PhrasingWeb.UILive

  @select_prompt [
    key: "Select",
    value: "",
    selected: true,
    disabled: true,
  ]

  def mount(socket) do
    {:ok, assign(socket, editing?: true)}
  end

  def update(a, socket) do
    changeset = a.phrase
    |> Dict.change_phrase()
    |> ensure_extra_translation()

    {:ok, assign(socket, Map.put(a, :changeset, changeset))}
  end

  def preload(list_of_assigns) do
    languages = Dict.list_languages()
    language_options = languages
    |> Enum.map(&([key: &1.name, value: &1.id]))
    |> List.insert_at(0, @select_prompt)

    Enum.map(list_of_assigns, fn assigns ->
      assigns
      |> Map.put(:languages, languages)
      |> Map.put(:language_options, language_options)
    end)
  end

  def render(assigns) do
    [source | translation_list] = Phrase.translation_list(assigns.phrase)

    ~L"""
    <div class="search--phrase">
      <%= if @editing? do %>

        <%= f = form_for @changeset, "#", [phx_change: :change, phx_submit: :save] %>
          <%= hidden_input f, :user_id, value: @user_id %>
          <%= hidden_input f, :source %>
          <%= ff = inputs_for f, :translations, fn ff -> %>
            <fieldset class="translation">
              <%= select ff, :language_id, @language_options %>
              <%= text_input ff, :text %>
              <div class="remove" phx-click="remove" phx-value-index="<%= ff.index %>">
                <i class="far fa-times"></i>
              </div>
            </fieldset>
          <% end %>

          <aside class="action" phx-click="save" phx-value-close="true">
            <i class="far fa-check"></i>
          </aside>
        </form>

      <% else %>

        <main>
          <div class="source"><%= source.text %></div>
          <%= for trans <- translation_list do %>
            <div class="translation"><%= trans.text %></div>
          <% end %>

          <aside class="action" phx-click="edit">
            <i class="far fa-pencil"></i>
          </aside>
        </main>

      <% end %>
    </div>
    """
  end

  def handle_event("edit", _params, socket) do
    {:noreply, assign(socket, editing?: true)}
  end

  def handle_event("change", %{"phrase" => phrase_params}, socket) do
    IO.inspect phrase_params, label: :phrase_params

    changeset = %Phrase{}
    |> Dict.change_phrase(phrase_params)
    |> ensure_extra_translation

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove", %{"index" => index}, socket) do
    translations = get_field(socket.assigns.changeset, :translations)
    |> List.delete_at(String.to_integer(index))

    changeset = socket.assigns.changeset
    |> put_change(:translations, translations)
    |> Map.put(:action, :ignore)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"close" => close}, socket) do
    case Dict.create_or_update_phrase(socket.assigns.changeset) do
      {:ok, phrase} ->
        IO.inspect phrase, label: :ok
        changeset = Dict.change_phrase(phrase)
        editing? = close == "true"
        {:noreply, assign(socket, changeset: changeset, editiing?: editing?)}
      {:error, changeset} ->
        IO.inspect changeset, label: :error
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp ensure_extra_translation(changeset) do
    translations = get_field changeset, :translations
    with_extra_translation = if Enum.any?(translations, &is_blank_translation?/1) do
      translations
    else
      translations ++ [%Translation{}]
    end

    changeset
# |> put_assoc(:translations, with_extra_translation)
    |> put_assoc(:translations, with_extra_translation |> Enum.map(fn x -> Map.put(x, :action, :ignore) end))
    |> Map.put(:action, :ignore)
  end

  defp is_blank_translation?(translation) do
    translation.language_id == nil && translation.text == nil
  end
end
