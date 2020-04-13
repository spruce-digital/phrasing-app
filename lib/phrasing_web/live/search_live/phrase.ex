defmodule PhrasingWeb.SearchLive.Phrase do
  use Phoenix.LiveComponent
  alias PhrasingWeb.Router.Helpers, as: Routes
  alias PhrasingWeb.UILive

  def render(assigns) do
    ~L"""
    <div class="search--phrase" phx-click="show_phrase" phx-target="<%= @myself %>">
      <main>
        <ul class="translations">
          <%= for tr <- @phrase.translations do %>
            <%= live_component @socket, UILive.Translation, id: tr.id,
              translation: tr
            %>
          <% end %>
        </ul>
      </main>
    </div>
    """
  end

  def handle_event("show_phrase", _params, socket) do
    path = Routes.phrase_edit_path(socket, :show, socket.assigns.phrase.id)
    {:noreply, push_redirect(socket, to: path)}
  end
end
