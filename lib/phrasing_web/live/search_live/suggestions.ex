defmodule PhrasingWeb.SearchLive.Suggestions do
  use Phoenix.LiveComponent

  alias PhrasingWeb.SearchLive

  def get_suggestion_trs(assigns) do
    search = assigns.search
    languages = assigns.languages

    assigns.phrases
    |> Enum.uniq()
    |> Enum.map(fn phrase ->
      phrase.translations
      |> Enum.filter(fn tr -> String.contains?(tr.text, search.text) end)
      |> Enum.uniq()
      |> Enum.map(fn tr ->
        language = Enum.find(languages, fn l -> l.id == tr.language_id end)
        {language, tr}
      end)
    end)
    |> List.flatten()
    |> Enum.uniq()
  end

  def render(assigns) do
    trs = get_suggestion_trs(assigns)

    ~L"""
    <div class="search--suggestions">
      <%= for {language, tr} <- trs do %>
        <div style="font-family: 'Operator Mono', monospace">
          <%= "#{language.code} : #{tr.text}" %>
        </div>
      <% end %>
    </div>
    """
  end
end
