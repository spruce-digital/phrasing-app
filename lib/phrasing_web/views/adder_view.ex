defmodule PhrasingWeb.AdderView do
  use PhrasingWeb, :view
  alias Phrasing.Dict.Phrase

  def language_name language_code do
    Phrase.languages
    |> Enum.find(fn x -> x[:value] == language_code end)
    |> Access.get(:key)
  end
end
