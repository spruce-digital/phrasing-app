ExCheck.start()
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Phrasing.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
