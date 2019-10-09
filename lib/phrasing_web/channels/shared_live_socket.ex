defmodule PhrasingWeb.SharedLiveSocket do
  use Phoenix.Socket

  if Version.match?(System.version(), ">= 1.8.0") do
    @derive {Inspect, only: [:id, :endpoint, :view, :parent_pid, :root_id, :assigns, :changed]}
  end

  defstruct id: nil,
            endpoint: nil,
            view: nil,
            parent_pid: nil,
            root_pid: nil,
            assigns: %{},
            changed: %{},
            private: %{},
            fingerprints: Phoenix.LiveView.Diff.new_fingerprints(),
            redirected: nil,
            connected?: false

  @type t :: %__MODULE__{}
  @type unsigned_params :: map
  @type assigns :: map

  channel "lv:*", Phoenix.LiveView.Channel
  channel "translate:*", PhrasingWeb.TranslateChannel

  @impl Phoenix.Socket
  def connect(_params, %Phoenix.Socket{} = socket, _connect_info) do
    {:ok, socket}
  end

  @impl Phoenix.Socket
  def id(_socket), do: nil
end
