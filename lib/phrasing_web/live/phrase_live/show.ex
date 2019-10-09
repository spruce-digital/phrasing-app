defmodule PhrasingWeb.PhraseLive.Show do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias Phrasing.Dict.Phrase
  alias PhrasingWeb.PhraseView

  def mount(%{id: id}, socket) do
    phrase = Dict.get_phrase!(id)
    {:ok, assign(socket, phrase: phrase)}
  end

  def render(assigns) do
    PhraseView.render("show.html", assigns)
  end
end
