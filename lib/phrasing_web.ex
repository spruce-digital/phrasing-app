defmodule PhrasingWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use PhrasingWeb, :controller
      use PhrasingWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: PhrasingWeb

      import Plug.Conn
      import PhrasingWeb.Gettext
      import Phoenix.LiveView.Controller
      import PhrasingWeb.Helpers.Auth, only: [check_auth: 2]
      alias PhrasingWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/phrasing_web/templates",
        namespace: PhrasingWeb,
        pattern: "**/*"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import PhrasingWeb.ErrorHelpers
      import PhrasingWeb.Gettext
      import Phoenix.LiveView.Helpers
      import PhrasingWeb.Helpers.Auth, only: [signed_in?: 1]
      alias PhrasingWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import PhrasingWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
