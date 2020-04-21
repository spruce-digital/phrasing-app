defmodule PhrasingWeb.LibraryLive.Index do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}

  alias Phrasing.Library
  alias PhrasingWeb.Router.Helpers, as: Routes

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    socket =
      socket
      |> assign(user_id: user_id)
      |> assign(dialogues: Library.list_dialogues())

    {:ok, assign(socket, user_id: user_id)}
  end

  def render(assigns) do
    ~L"""
    <section class="library--index">
      <section class="library--index--dialogues g--container">
        <header>
          <h2>Dialogues</h2>
        </header>

        <main>
          <%= for d <- @dialogues do %>
            <%= live_redirect to: Routes.dialogue_edit_path(@socket, :edit, d.id) do %>
              <div><%= d.title %></div>
            <% end %>
          <% end %>
        </main>

        <footer>
          <button class="g--button" phx-click="create_dialogue">
            New Dialogue
          </button>
        </footer>
      </section>
    </section>
    """
  end

  def handle_event("create_dialogue", _params, socket) do
    params = %{
      author_id: socket.assigns.user_id,
      title: "New Dialogue"
    }

    case Library.create_dialogue(params) do
      {:ok, dialogue} ->
        socket =
          socket
          |> push_redirect(to: Routes.dialogue_edit_path(socket, :edit, dialogue.id))

        {:noreply, socket}

      {:error, _error} ->
        socket =
          socket
          |> put_flash(:error, "Could not create Dialogue")

        {:noreply, socket}
    end
  end
end
