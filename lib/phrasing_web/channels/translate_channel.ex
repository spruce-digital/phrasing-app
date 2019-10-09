defmodule PhrasingWeb.TranslateChannel do
  use PhrasingWeb, :channel

  def join("translate:lobby", _payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (translation:lobby).
  def handle_in("translate", payload, socket) do
    IO.puts "translate from channel"
    broadcast socket, "translate", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
