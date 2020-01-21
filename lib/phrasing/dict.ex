defmodule Phrasing.Dict do
  @moduledoc """
  The Dict context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Phrasing.Repo

  alias Phrasing.Dict.Phrase

  @topic "phrases"

  def subscribe do
    Phoenix.PubSub.subscribe(Phrasing.PubSub, @topic)
  end

  def get_last_translations(user_id: user_id, language_id: language_id) do
    query =
      from p in Phrase,
        where: p.user_id == ^user_id,
        where: p.language_id == ^language_id,
        select: {p.translations},
        limit: 1

    case Repo.all(query) do
      [] ->
        []

      [{translations}] ->
        translations
        |> Enum.map(fn t -> to_string(t.language_id) end)
        |> Enum.filter(fn id -> id != language_id end)
        |> Enum.map(&String.to_integer/1)
    end
  end

  def search_translations_query(query) do
    ilike_query = "%#{query}%"

    from p in Phrase,
      join: t in assoc(p, :translations),
      where: ilike(t.text, ^ilike_query),
      order_by: fragment("length(?)", t.text),
      preload: [:translations]
  end

  def search_translations(query) do
    query
    |> search_translations_query()
    |> Repo.all()
  end

  def search_translations(query, nil), do: search_translations(query)
  def search_translations(query, ""), do: search_translations(query)

  def search_translations(query, language_id) do
    Repo.all(
      from [p, t] in search_translations_query(query),
        where: t.language_id == ^language_id
    )
  end

  @doc """
  Returns the list of phrases.

  ## Examples

      iex> list_phrases()
      [%Phrase{}, ...]

  """
  def list_phrases_query do
    from p in Phrase,
      where: p.active == true,
      order_by: [desc: p.updated_at],
      preload: [:cards, :translations]
  end

  def list_phrases do
    Repo.all(list_phrases_query)
  end

  def list_phrases(user_id) do
    Repo.all(
      from p in list_phrases_query,
        where: p.user_id == ^user_id
    )
  end

  @doc """
  Gets a single phrase.

  Raises `Ecto.NoResultsError` if the Phrase does not exist.

  ## Examples

      iex> get_phrase!(123)
      %Phrase{}

      iex> get_phrase!(456)
      ** (Ecto.NoResultsError)

  """
  def get_phrase!(id), do: Repo.get!(Phrase, id)

  def get_last_phrase_for_user(user_id) do
    query =
      from p in Phrase,
        where: p.user_id == ^user_id,
        limit: 1

    query
    |> Repo.all()
    |> List.first()
  end

  @doc """
  Create a phrase if none exists. Update the phrase othersie.
  If translations are passed in, subsequently create or update those
  """
  def create_or_update_phrase(attrs \\ %{}) do
    {id, attrs} =
      attrs
      |> Map.new(fn {k, v} -> {to_string(k), v} end)
      |> Map.pop("id")

    if id do
      id
      |> get_phrase!()
      |> update_phrase(attrs)
    else
      create_phrase(attrs)
    end
  end

  def create_or_update_phrase(attrs, translations) do
    case create_or_update_phrase(attrs) do
      {:ok, phrase} ->
        phrase
        |> Repo.preload(:translations)
        |> Phrase.translations_changeset(%{"translations" => translations})
        |> Repo.update()
    end
  end

  @doc """
  Creates a phrase.

  ## Examples

      iex> create_phrase(%{field: value})
      {:ok, %Phrase{}}

      iex> create_phrase(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_phrase(attrs \\ %{}) do
    dry_changeset =
      %Phrase{}
      |> Phrase.dry_changeset(attrs)

    if dry_changeset.valid? do
      with phrase_changeset <- Phrase.phrase_changeset(%Phrase{}, attrs),
           {:ok, %Phrase{} = phrase_raw} <- Repo.insert(phrase_changeset),
           translation_changeset <- Phrase.translations_changeset(phrase_raw, attrs),
           {:ok, %Phrase{} = phrase} <- Repo.update(translation_changeset) do
        {:ok, phrase}
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          {:error, changeset}
      end
    else
      {:error, dry_changeset}
    end

    # |> notify_dict_subscribers(:phrase_update)
  end

  def create_phrase_from_adder(attrs \\ %{}) do
    %Phrase{}
    |> Phrase.adder_changeset(attrs)
    |> Repo.insert()
    |> notify_dict_subscribers(:phrase_update)
  end

  def create_phrase_from_search(attrs \\ %{}) do
    %Phrase{}
    |> Phrase.search_changeset(attrs)
    |> Repo.insert()
  end

  def notify_dict_subscribers({:ok, payload}, event) do
    Phoenix.PubSub.broadcast(Phrasing.PubSub, @topic, {event, payload})
    {:ok, payload}
  end

  @doc """
  Updates a phrase.

  ## Examples

      iex> update_phrase(phrase, %{field: new_value})
      {:ok, %Phrase{}}

      iex> update_phrase(phrase, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_phrase(%Phrase{} = phrase, attrs) do
    with phrase_changeset <- Phrase.changeset(phrase, attrs),
         {:ok, %Phrase{} = phrase_raw} <- Repo.update(phrase_changeset),
         translation_changeset <- Phrase.translations_changeset(phrase_raw, attrs),
         {:ok, %Phrase{} = phrase} <- Repo.update(translation_changeset) do
      {:ok, phrase}
    end
  end

  @doc """
  Updates or creates a phrase.
  """
  def save_phrase(attrs) do
    if attrs["id"] == "" do
      create_phrase(attrs)
    else
      update_phrase(get_phrase!(attrs["id"]), attrs)
    end
  end

  @doc """
  Deletes a Phrase.

  ## Examples

      iex> delete_phrase(phrase)
      {:ok, %Phrase{}}

      iex> delete_phrase(phrase)
      {:error, %Ecto.Changeset{}}

  """
  def delete_phrase(%Phrase{} = phrase) do
    Repo.delete(phrase)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking phrase changes.

  ## Examples

      iex> change_phrase(phrase)
      %Ecto.Changeset{source: %Phrase{}}

  """
  def change_phrase(%Phrase{} = phrase, attrs \\ %{}) do
    Phrase.changeset(phrase, attrs)
  end

  alias Phrasing.Dict.Entry

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries do
    Repo.all(Entry)
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_entry!(123)
      %Entry{}

      iex> get_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entry!(id), do: Repo.get!(Entry, id)

  @doc """
  Creates a entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs \\ %{}) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entry.

  ## Examples

      iex> update_entry(entry, %{field: new_value})
      {:ok, %Entry{}}

      iex> update_entry(entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Entry.

  ## Examples

      iex> delete_entry(entry)
      {:ok, %Entry{}}

      iex> delete_entry(entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.

  ## Examples

      iex> change_entry(entry)
      %Ecto.Changeset{source: %Entry{}}

  """
  def change_entry(%Entry{} = entry) do
    Entry.changeset(entry, %{})
  end

  alias Phrasing.Dict.Language

  @doc """
  Returns the list of languages.

  ## Examples

      iex> list_languages()
      [%Language{}, ...]

  """
  def list_languages do
    Repo.all(Language)
  end

  @doc """
  Gets a single language.

  Raises `Ecto.NoResultsError` if the Language does not exist.

  ## Examples

      iex> get_language!(123)
      %Language{}

      iex> get_language!(456)
      ** (Ecto.NoResultsError)

  """
  def get_language!(id), do: Repo.get!(Language, id)

  @doc """
  Creates a language.

  ## Examples

      iex> create_language(%{field: value})
      {:ok, %Language{}}

      iex> create_language(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_language(attrs \\ %{}) do
    %Language{}
    |> Language.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a language.

  ## Examples

      iex> update_language(language, %{field: new_value})
      {:ok, %Language{}}

      iex> update_language(language, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_language(%Language{} = language, attrs) do
    language
    |> Language.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Language.

  ## Examples

      iex> delete_language(language)
      {:ok, %Language{}}

      iex> delete_language(language)
      {:error, %Ecto.Changeset{}}

  """
  def delete_language(%Language{} = language) do
    Repo.delete(language)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking language changes.

  ## Examples

      iex> change_language(language)
      %Ecto.Changeset{source: %Language{}}

  """
  def change_language(%Language{} = language, attrs \\ %{}) do
    Language.changeset(language, %{})
  end

  alias Phrasing.Dict.Translation

  @doc """
  Returns the list of translations.

  ## Examples

      iex> list_translations()
      [%Translation{}, ...]

  """
  def list_translations do
    Repo.all(Translation)
  end

  @doc """
  Gets a single translation.

  Raises `Ecto.NoResultsError` if the Translation does not exist.

  ## Examples

      iex> get_translation!(123)
      %Translation{}

      iex> get_translation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_translation!(id), do: Repo.get!(Translation, id)

  @doc """
  Creates a translation.

  ## Examples

      iex> create_translation(%{field: value})
      {:ok, %Translation{}}

      iex> create_translation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_translation(attrs \\ %{}) do
    %Translation{}
    |> Translation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a translation.

  ## Examples

      iex> update_translation(translation, %{field: new_value})
      {:ok, %Translation{}}

      iex> update_translation(translation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_translation(%Translation{} = translation, attrs) do
    translation
    |> Translation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Translation.

  ## Examples

      iex> delete_translation(translation)
      {:ok, %Translation{}}

      iex> delete_translation(translation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_translation(%Translation{} = translation) do
    Repo.delete(translation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking translation changes.

  ## Examples

      iex> change_translation(translation)
      %Ecto.Changeset{source: %Translation{}}

  """
  def change_translation(%Translation{} = translation) do
    Translation.changeset(translation, %{})
  end
end
