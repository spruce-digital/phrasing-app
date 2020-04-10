defmodule PhrasingWeb.UILive.Field.Date do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form

  def render(assigns) do
    ~L"""
    <article class="ui--field <%= if @activated, do: "activated" %>" id="<%= @id %>">
      <header>
        <%= label @form, @attr %>
      </header>

      <main>
        <%= if assigns[:icon] do %>
          <i class="icon <%= @icon %>"></i>
        <% end %>

        <%= date_input @form, @attr,
          placeholder: @placeholder,
          phx_focus: :focus,
          phx_blur: :blur,
          phx_target: "##{@id}"
        %>
      </main>
    </article>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, activated: false, placeholder: "YYYY-MM-DD")}
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
