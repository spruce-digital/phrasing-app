defmodule Phrasing.TranslatorBridge do
  use GenServer
  require Logger

  def start_link(_state) do
    GenServer.start_link __MODULE__, %{}
  end

  # Server

  def init(_state) do
    Logger.warn "Phrasing.TranslatorBridge server started"
    {:ok, %{}}
  end

  def broadcast(phrase) do
    PhrasingWeb.Endpoint.broadcast! "translation:lobby", "translation", %{
      phrase: phrase,
    }
  end
end
