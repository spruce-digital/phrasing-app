defmodule PhrasingWeb.BookLive.New do
  use Phoenix.LiveView

  alias PhrasingWeb.BookView

  def mount(_session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    BookView.render("new.html", assigns)
  end
end
