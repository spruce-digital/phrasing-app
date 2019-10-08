defmodule PhrasingWeb.PhraseLive.Index do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias PhrasingWeb.PhraseView

  def mount(_session, socket) do
    phrases = Dict.list_phrases()
    {:ok, assign(socket, phrases: phrases)}
  end

  def render(assigns) do
    PhraseView.render("index.html", assigns)
  end
end
