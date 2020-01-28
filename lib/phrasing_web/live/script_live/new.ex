defmodule PhrasingWeb.ScriptLive.New do
  use Phoenix.LiveView

  alias Phrasing.Library
  alias PhrasingWeb.ScriptView
  alias PhrasingWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    changeset = Library.change_script(%Library.Script{})
    languages = []

    {:ok, assign(socket, changeset: changeset, languages: languages, add_translation: nil)}
  end

  def render(assigns) do
    ScriptView.render("new.html", assigns)
  end

  def handle_event("language_select", %{"field" => _field}, socket) do
    languages = socket.assigns.languages ++ [socket.assigns.add_translation]
    changeset = Map.put(socket.assigns.changeset, :action, :ignore)

    {:noreply, assign(socket, languages: languages, changeset: changeset, add_translation: nil)}
  end

  def handle_event("change", %{"script" => script_params}, socket) do
    changeset =
      %Library.Script{}
      |> Library.change_script(script_params)
      |> Map.put(:action, :ignore)

    languages =
      [script_params["lang"] | script_params["translations"] || []]
      |> Enum.filter(& &1)

    add_translation = List.first(script_params["add_translation"] || [])

    {:noreply,
     assign(socket, changeset: changeset, languages: languages, add_translation: add_translation)}
  end

  def handle_event("create", %{"script" => script_params}, socket) do
    case Library.create_script(script_params) do
      {:ok, _script} ->
        {:stop,
         socket
         |> put_flash(:info, "Script created successfully.")
         |> redirect(to: Routes.library_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
