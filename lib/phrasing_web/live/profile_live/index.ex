defmodule PhrasingWeb.ProfileLive.Index do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias Phrasing.Accounts
  alias Phrasing.Accounts.Profile
  alias Phrasing.Dict
  alias PhrasingWeb.Helpers.LanguageLevel

  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset, "#", [phx_change: :validate, phx_submit: :save] %>
      <%= hidden_input f, :id %>

      <h2 style="font-family: Baveuse">Profile</h2>
      <%= inputs_for f, :profile, fn ff -> %>
        <%= label ff, :name %>
        <%= text_input ff, :name %>

        <%= label ff, :birthday %>
        <%= date_select ff, :birthday %>

        <%= label ff, :gender %>
        <%= select ff, :gender, ["Male": "male", "Female": "female", "Other": "other"], prompt: "Select" %>
      <% end %>

      <h2 style="font-family: Baveuse">Languages</h2>
      <%= for lang <- @languages do %>
        <div>
          <%= lang.name %>

          <input
            type="checkbox"
            <%= if LanguageLevel.get_level(@changeset, lang) == 0, do: "checked" %>
            name="<%= f.name %>[language_levels][<%= lang.id %>][learning]"/>
          Learning

          <input
            type="checkbox"
            <%= if LanguageLevel.get_level(@changeset, lang) == 100, do: "checked" %>
            name="<%= f.name %>[language_levels][<%= lang.id %>][native]"/>
          Native
        </div>
      <% end %>

      <%= submit "Save" %>
    </form>
    """
  end

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    languages = Dict.list_languages()

    user =
      user_id
      |> Accounts.get_user!()
      |> Phrasing.Repo.preload([:profile, :user_languages])

    changeset = Accounts.change_user(user)

    {:ok, assign(socket, user_id: user_id, changeset: changeset, languages: languages, user: user)}
  end

  def parse_params(user_params, user_id) do
    Map.put(
      user_params,
      "user_languages",
      LanguageLevel.to_user_languages(user_params["language_levels"],
        user_id: user_id
      )
    )
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    user_params = parse_params(user_params, socket.assigns.user.id)

    changeset =
      socket.assigns.changeset.data
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user_params = parse_params(user_params, socket.assigns.user.id)

    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        {:noreply,
          socket
          |> put_flash(:info, "Profile updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
