defmodule PhrasingWeb.SongLive.New do
  use Phoenix.LiveView

  alias PhrasingWeb.SongView

  def mount(_session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    SongView.render("new.html", assigns)
  end
end
