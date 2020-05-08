defmodule PhrasingWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :phrasing
  use Sentry.Phoenix.Endpoint

  @session_options [
    store: :cookie,
    key: "_phrasing_key",
    signing_salt: "MgQ0zgyN"
  ]

  @origins ["//phrasing.app", "//www.phrasing.app", "http://localhost:8280/"]

  socket "/socket", PhrasingWeb.UserSocket,
    websocket: true,
    longpoll: false,
    check_origin: @origins

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    check_origin: @origins

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :phrasing,
    gzip: false,
    only: ~w(fa css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session, @session_options

  plug CORSPlug,
    origin: ["http://localhost:4500"]

  plug PhrasingWeb.Router
end
