defmodule PhrasingWeb.UILive.Field.Password do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form

  def render(assigns) do
    ~L"""
    <article class="ui--field <%= if @activated, do: "activated" %>" id="<%= @id %>">
      <header>
        <%= if assigns[:label] do %>
          <%= label @form, @attr, @label %>
        <% else %>
          <%= label @form, @attr %>
        <% end %>
      </header>

      <main>
        <%= if assigns[:icon] do %>
          <i class="icon <%= @icon %>"></i>
        <% end %>

        <%= password_input @form, @attr,
          phx_focus: :focus,
          phx_blur: :blur,
          phx_target: "##{@id}",
          value: input_value(@form, @attr)
        %>
      </main>
    </article>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, activated: false)}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:attr, assigns[:attr] || assigns[:id])

    {:ok, socket}
  end

  def handle_event("focus", _params, socket) do
    {:noreply, assign(socket, activated: true)}
  end

  def handle_event("blur", _params, socket) do
    value = input_value(socket.assigns.form, socket.assigns.attr)

    if value == nil || value == "" do
      {:noreply, assign(socket, activated: false)}
    else
      {:noreply, socket}
    end
  end
end
