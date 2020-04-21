defmodule PhrasingWeb.DialogueLive.Edit do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}

  def mount(params, %{"current_user_id" => user_id}, socket) do
    IO.inspect(params)
    {:ok, assign(socket, user_id: user_id)}
  end

  def render(assigns) do
    ~L"""
    Dialogue
    """
  end
end
