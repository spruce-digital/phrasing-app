defmodule PhrasingWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.
  """
  use Phoenix.Presence,
    otp_app: :phrasing,
    pubsub_server: Phrasing.PubSub

end
