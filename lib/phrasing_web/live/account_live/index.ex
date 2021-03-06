defmodule PhrasingWeb.AccountLive.Index do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias Phrasing.Account
  alias Phrasing.Account.Profile
  alias Phrasing.Dict
  alias PhrasingWeb.Helpers.LanguageLevel
  alias PhrasingWeb.UILive.Field

  def form_opts, do: [phx_change: :validate, phx_submit: :save, id: __MODULE__]

  def getLanguageName(languages, id) do
    Enum.find(languages, fn l -> to_string(l.id) == to_string(id) end).name
  end

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    languages = Dict.list_languages()

    if Phrasing.Repo.get_by(Account.Profile, user_id: user_id) == nil do
      Account.create_profile(%{user_id: user_id})
    end

    user =
      user_id
      |> Account.get_user!()
      |> Phrasing.Repo.preload([:profile, :user_languages])

    changeset = Account.change_form(%Account.Form{}, user)

    {:ok,
     assign(socket, user_id: user_id, changeset: changeset, languages: languages, user: user)}
  end

  def handle_event("validate", %{"form" => form_params}, socket) do
    changeset =
      socket.assigns.changeset.data
      |> Account.change_form(form_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"form" => form_params}, socket) do
    case Account.update_user(socket.assigns.user, form: form_params) do
      {:ok, user} ->
        socket =
          socket
          |> assign(user: user)
          |> assign(changeset: Account.change_form(%Account.Form{}, user))
          |> put_flash(:success, "Account successfully updated")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(changeset: changeset)
          |> put_flash(:error, "An error occurred")

        {:noreply, socket}
    end

    # case Account.update_user(socket.assigns.user, user_params) do
    #   {:ok, user} ->
    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "Profile updated successfully")}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, changeset: changeset)}
    # end
  end
end
