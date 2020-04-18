defmodule PhrasingWeb.UILive.Field.Select do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form

  @defaults %{
    form_selector: nil
  }

  def render_label(assigns, ""), do: ""

  def render_label(assigns, value) do
    vopts = assigns.visible_options

    cond do
      assigns[:labels] && value ->
        index = Enum.find_index(vopts, &(to_string(&1) == to_string(value)))
        Enum.at(assigns.labels, index, value)

      assigns[:getLabel] && value ->
        assigns.getLabel.(value)

      true ->
        value
    end
  end

  def render(assigns) do
    ~L"""
    <article
      class="ui--field--select <%= if @active, do: "active" %>"
      id="<%= @id %>"
      phx-hook="SelectField"
      data-form-selector=<%= @form_selector %>
    >
      <%= hidden_input @form, @attr %>

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
            value="<%= @value %>"
          />
        </form>

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
    {:ok, assign(socket, active: false, visible_options: [])}
  end

  def update(assigns, socket) do
    attr = assigns[:attr] || assigns[:id]

    socket =
      socket
      |> assign(@defaults)
      |> assign(assigns)
      |> assign_languages(assigns[:languages])
      |> assign_visible_options()
      |> assign(:attr, attr)
      |> assign_value()

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
    {:noreply, assign(socket, active: false, value: render_label(socket.assigns, value))}
  end

  defp assign_languages(socket, nil), do: socket

  defp assign_languages(socket, languages) do
    options = Enum.map(languages, & &1.id)
    labels = Enum.map(languages, & &1.name)
    assign(socket, options: options, labels: labels)
  end

  defp assign_visible_options(socket) do
    assign(socket, visible_options: socket.assigns.options)
  end

  defp assign_value(socket) do
    value = input_value(socket.assigns.form, socket.assigns.attr)
    assign(socket, value: render_label(socket.assigns, value))
  end
end
