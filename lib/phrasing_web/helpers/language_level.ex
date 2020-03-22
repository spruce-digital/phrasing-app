defmodule PhrasingWeb.Helpers.LanguageLevel do
  alias Phrasing.Accounts.UserLanguage

  def to_user_languages(nil, user_id: user_id), do: []
  def to_user_languages(language_levels, user_id: user_id) do
    Enum.reduce(language_levels, [], fn {id, attrs}, acc ->
      add =
        case attrs do
          %{"native" => "on"} ->
            [%{"user_id" => user_id, "language_id" => id, "level" => "100"}]

          %{"learning" => "on"} ->
            [%{"user_id" => user_id, "language_id" => id, "level" => "0"}]

          _ ->
            []
        end

      acc ++ add
    end)
  end

  def get_level(%Ecto.Changeset{} = changeset, language) do
    Ecto.Changeset.get_field(changeset, :user_languages)
    |> Enum.find(%{}, &(&1.language_id == language.id))
    |> Map.get(:level, nil)
  end
end
