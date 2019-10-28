defmodule PhrasingWeb.AdderLive.Adder do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias Phrasing.Dict.Phrase
  alias PhrasingWeb.AdderView

  def mount(_session, socket) do
    changeset = Dict.change_phrase(%Phrase{})

    {:ok, assign(socket, open: true, changeset: changeset)}
  end

  def render(assigns) do
    AdderView.render("adder.html", assigns)
  end

  def handle_event("open", _params, socket) do
    {:noreply, assign(socket, open: true)}
  end
end
