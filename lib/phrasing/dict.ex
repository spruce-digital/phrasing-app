defmodule Phrasing.Dict do
  @moduledoc """
  The Dict context.
  """

  import Ecto.Query, warn: false
  alias Phrasing.Repo

  alias Phrasing.Dict.Phrase

  @topic "phrases"

  def subscribe do
    Phoenix.PubSub.subscribe(Phrasing.PubSub, @topic)
  end

  @doc """
  Returns the list of phrases.

  ## Examples

      iex> list_phrases()
      [%Phrase{}, ...]

  """
  def list_phrases do
    Repo.all from p in Phrase,
      where: p.active == true,
      order_by: [desc: p.updated_at],
      preload: :cards
  end
  def list_phrases(user_id) do
    Repo.all from p in Phrase,
      where: p.active == true,
      where: p.user_id == ^user_id,
      order_by: [desc: p.updated_at],
      preload: :cards
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
    query = from p in Phrase,
            where: p.user_id == ^user_id

    Repo.one(query)
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
    %Phrase{}
    |> Phrase.changeset(attrs)
    |> Repo.insert()
    # |> notify_dict_subscribers(:phrase_update)
  end

  def create_phrase_from_adder(attrs \\ %{}) do
    %Phrase{}
    |> Phrase.adder_changeset(attrs)
    |> Repo.insert()
    |> notify_dict_subscribers(:phrase_update)
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
    phrase
    |> Phrase.changeset(attrs)
    |> Repo.update()
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
    update_phrase(phrase, %{active: false})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking phrase changes.

  ## Examples

      iex> change_phrase(phrase)
      %Ecto.Changeset{source: %Phrase{}}

  """
  def change_phrase(%Phrase{} = phrase) do
    Phrase.changeset(phrase, %{})
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
end
