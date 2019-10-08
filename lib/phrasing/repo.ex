defmodule Phrasing.Repo do
  use Ecto.Repo,
    otp_app: :phrasing,
    adapter: Ecto.Adapters.Postgres
end
