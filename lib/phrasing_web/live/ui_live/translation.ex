defmodule PhrasingWeb.UILive.Translation do
  use Phoenix.LiveComponent

  alias Phrasing.SRS

  @defaults %{
    searched_for?: false,
    user_id: nil
  }

  def update(assigns, socket) do
    socket =
      socket
      |> assign(@defaults)
      |> assign(assigns)

    {:ok, socket}
  end

  def render(assigns) do
    active = !!Enum.find(assigns.translation.cards, & &1.active)

    ~L"""
    <li class="ui--translation">
      <aside>
        <span
          class="flag-icon flag-icon-squared flag-icon-<%= @translation.language.flag_code %>"
          title="<%= @translation.language.name %>"
        ></span>
      </aside>
      <div class="language-code">
        @<%= @translation.language.code %>
      </div>
      <main>
        <p class="text <%= if @searched_for?, do: "searched-for", else: "" %>">
          <%= @translation.text %>
        <p>
        <%= if @user_id do %>
          <div class="learn learn-<%= if active, do: "on", else: "off" %>"
              phx-click="<%= if active, do: "stop_learning", else: "learn" %>"
              phx-target="<%= @myself %>" phx-value-tr="<%= @translation.id %>">
              <i class="<%= if active, do: "fas", else: "fal" %> fa-paper-plane"></i>
          </div>
        <% end %>
      </main>
    </li>
    """
  end

  def handle_event("learn", %{"tr" => tr}, socket) do
    case SRS.learn(translation_id: tr, user_id: socket.assigns.user_id) do
      {:ok, _card} -> {:noreply, socket}
      {:error, _error} -> {:noreply, put_flash(socket, :error, "An error occurred")}
    end
  end

  def handle_event("stop_learning", %{"tr" => tr}, socket) do
    case SRS.stop_learning(translation_id: tr, user_id: socket.assigns.user_id) do
      {:ok, _card} -> {:noreply, socket}
      {:error, _error} -> {:noreply, put_flash(socket, :error, "An error occurred")}
    end
  end
end
