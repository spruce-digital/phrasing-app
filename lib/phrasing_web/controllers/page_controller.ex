defmodule PhrasingWeb.PageController do
  use PhrasingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
