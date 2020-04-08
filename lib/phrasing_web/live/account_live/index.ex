defmodule PhrasingWeb.AccountLive.Index do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias Phrasing.Accounts
  alias Phrasing.Accounts.Profile
  alias Phrasing.Dict
  alias PhrasingWeb.Helpers.LanguageLevel
  alias PhrasingWeb.UILive.Field

  def form_opts, do: [phx_change: :validate, phx_submit: :save, id: __MODULE__]

  def getLanguageName(languages, id) do
    Enum.find(languages, fn l -> to_string(l.id) == to_string(id) end).name
  end

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    languages = Dict.list_languages()

    user =
      user_id
      |> Accounts.get_user!()
      |> Phrasing.Repo.preload([:profile, :user_languages])

    changeset = Accounts.change_form(%Accounts.Form{})

    {:ok,
     assign(socket, user_id: user_id, changeset: changeset, languages: languages, user: user)}
  end

  def handle_event("validate", %{"form" => form_params}, socket) do
    IO.inspect(form_params)

    changeset =
      socket.assigns.changeset.data
      |> Accounts.change_form(form_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
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
