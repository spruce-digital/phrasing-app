defmodule PhrasingWeb.Plugs.AbsintheContext do
  @behaviour Plug

  import Plug.Conn
  import Ecto.Query

  alias Phrasing.{Repo, Account}

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
    {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    query = from u in Account.User,
      join: j in assoc(u, :jwts),
      where: j.token == ^token

    case Repo.one(query) do
      nil -> {:error, "invalid authorization token"}
      user -> {:ok, user}
    end
  end

end
