defmodule PhrasingWeb.PhraseView do
  use PhrasingWeb, :view

  alias Ecto.Changeset
  alias Phrasing.Dict.Phrase

  def get_field(changeset, field, default \\ nil) do
    Changeset.get_field(changeset, field, default)
  end

  def get_nested_error(error) when is_map(error) do
    error
    |> Map.values()
    |> List.flatten()
    |> Enum.filter(&(&1 != %{}))
  end
  def get_nested_error(error), do: error

  def get_all_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn _changeset, field, {msg, opts} -> "#{field} #{msg}" end)
    |> Map.values()
    |> List.flatten()
    |> Enum.filter(&(&1 != %{}))
    |> Enum.map(&get_nested_error/1)
    |> List.flatten()
    |> Enum.map(fn msg ->
      case msg do
        "language_id can't be blank" -> "One or more translations is missing a language"
        _ -> msg
      end
    end)
    |> Enum.uniq()
  end
end
