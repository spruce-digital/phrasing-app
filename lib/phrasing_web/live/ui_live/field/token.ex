defmodule PhrasingWeb.UILive.Field.Token do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form

  def render_label(assigns, value) do
    if assigns[:getLabel], do: assigns.getLabel.(value), else: value
  end

  def render(assigns) do
    ~L"""
    <article
      class="ui--field--token <%= if @active, do: "active" %>"
      id="<%= @id %>"
      phx-hook="TokenField"
    >
      <%= if input_value(@form, @attr) != @value do %>
        <input type="hidden" form="<%= @change_target %>" data-stale />
      <% end %>
      <header>
        <%= label @form, @attr %>
      </header>

      <main>
        <%= if assigns[:icon] do %>
          <i class="icon <%= @icon %>"></i>
        <% end %>

        <form phx-change="filter" phx-target="<%= @myself %>">
          <input
            name="query"
            phx-focus="focus"
            phx-target="<%= @myself %>"
          />
        </form>

        <div class="token-list">
          <%= for {v, i} <- Enum.with_index(@value) do %>
            <input
              type="hidden"
              form="<%= @change_target %>"
              name="<%= input_name @form, @attr %>[]"
              id="<%= input_id @form, @attr, i %>"
              value="<%= v %>"
            />

            <div class="token" data-value="<%= v %>">
              <%= render_label(assigns, v) %>
            </div>
          <% end %>
        </div>

        <%= if @active do %>
          <aside class="dropdown">
            <ul>
              <%= for option <- @visible_options do %>
                <li data-value="<%= option %>">
                  <%= render_label(assigns, option) %>
                </li>
              <% end %>
            </ul>
          </aside>
        <% end %>
      </main>
    </article>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, active: false, visible_options: [], value: [])}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(visible_options: assigns[:options])
      |> assign(value: input_value(assigns.form, assigns.attr))

    {:ok, socket}
  end

  def handle_event("focus", _params, socket) do
    {:noreply, assign(socket, active: true)}
  end

  def handle_event("blur", params, socket) do
    {:noreply, assign(socket, active: false)}
  end

  def handle_event("filter", %{"query" => query}, socket) do
    visible_options =
      socket.assigns.options
      |> Enum.filter(fn opt ->
        render_label(socket.assigns, opt)
        |> to_string()
        |> String.downcase()
        |> String.contains?(String.downcase(query))
      end)

    {:noreply, assign(socket, visible_options: visible_options)}
  end

  def handle_event("select", %{"value" => value}, socket) do
    value =
      (socket.assigns.value ++ [value])
      |> Enum.uniq()

    {:noreply, assign(socket, value: value)}
  end

  def handle_event("destroy", %{"value" => value}, socket) do
    value =
      socket.assigns.value
      |> Enum.filter(fn v -> v != value end)

    {:noreply, assign(socket, value: value)}
  end
end
