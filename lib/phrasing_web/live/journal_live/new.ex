defmodule PhrasingWeb.JournalLive.New do
  use Phoenix.LiveView

  alias PhrasingWeb.JournalView

  def mount(_session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    JournalView.render("new.html", assigns)
  end
end
