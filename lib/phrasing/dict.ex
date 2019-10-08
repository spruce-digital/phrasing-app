defmodule Phrasing.Dict do
  @moduledoc """
  The Dict context.
  """

  import Ecto.Query, warn: false
  alias Phrasing.Repo

  alias Phrasing.Dict.Phrase

  @doc """
  Returns the list of phrases.

  ## Examples

      iex> list_phrases()
      [%Phrase{}, ...]

  """
  def list_phrases do
    Repo.all(Phrase)
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
    Repo.delete(phrase)
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
end
