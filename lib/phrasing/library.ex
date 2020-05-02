defmodule Phrasing.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias Phrasing.Repo
  alias Phrasing.Dict

  alias Phrasing.Library.Dialogue

  @doc """
  Returns the list of dialogues.

  ## Examples

      iex> list_dialogues()
      [%Dialogue{}, ...]

  """
  def list_dialogues do
    Repo.all(Dialogue)
  end

  @doc """
  Gets a single dialogue.

  Raises `Ecto.NoResultsError` if the Dialogue does not exist.

  ## Examples

      iex> get_dialogue!(123)
      %Dialogue{}

      iex> get_dialogue!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dialogue!(id), do: Repo.get!(Dialogue, id)

  @doc """
  Creates a dialogue.

  ## Examples

      iex> create_dialogue(%{field: value})
      {:ok, %Dialogue{}}

      iex> create_dialogue(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dialogue(attrs \\ %{}) do
    %Dialogue{}
    |> Dialogue.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dialogue.

  ## Examples

      iex> update_dialogue(dialogue, %{field: new_value})
      {:ok, %Dialogue{}}

      iex> update_dialogue(dialogue, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dialogue(%Dialogue{} = dialogue, attrs) do
    dialogue
    |> Dialogue.changeset(attrs)
    |> Repo.update()
    |> notify_dialogue_subscribers(:update)
  end

  @doc """
  Deletes a dialogue.

  ## Examples

      iex> delete_dialogue(dialogue)
      {:ok, %Dialogue{}}

      iex> delete_dialogue(dialogue)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dialogue(%Dialogue{} = dialogue) do
    Repo.delete(dialogue)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dialogue changes.

  ## Examples

      iex> change_dialogue(dialogue)
      %Ecto.Changeset{source: %Dialogue{}}

  """
  def change_dialogue(%Dialogue{} = dialogue, attrs \\ %{}) do
    Dialogue.changeset(dialogue, attrs)
  end

  alias Phrasing.Library.DialogueLine

  @doc """
  Returns the list of dialogue_lines.

  ## Examples

      iex> list_dialogue_lines()
      [%DialogueLine{}, ...]

  """
  def list_dialogue_lines do
    Repo.all(DialogueLine)
  end

  @doc """
  Gets a single dialogue_line.

  Raises `Ecto.NoResultsError` if the Dialogue line does not exist.

  ## Examples

      iex> get_dialogue_line!(123)
      %DialogueLine{}

      iex> get_dialogue_line!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dialogue_line!(id), do: Repo.get!(DialogueLine, id)

  @doc """
  Creates a dialogue_line.

  ## Examples

      iex> create_dialogue_line(%{field: value})
      {:ok, %DialogueLine{}}

      iex> create_dialogue_line(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dialogue_line(attrs \\ %{}) do
    %DialogueLine{}
    |> DialogueLine.changeset(attrs)
    |> Repo.insert()
  end

  def create_dialogue_line(attrs, user_id: user_id, language_id: language_id) do
    Repo.transaction(fn ->
      {:ok, phrase} = Dict.create_phrase(%{"user_id" => user_id})

      {:ok, translation} =
        Dict.create_translation(%{
          "phrase_id" => phrase.id,
          "language_id" => language_id,
          "text" => attrs["translation"]
        })

      {:ok, line} = create_dialogue_line(Map.put(attrs, "phrase_id", phrase.id))

      line
    end)
    |> notify_dialogue_subscribers(:line_update)
  end

  @doc """
  Updates a dialogue_line.

  ## Examples

      iex> update_dialogue_line(dialogue_line, %{field: new_value})
      {:ok, %DialogueLine{}}

      iex> update_dialogue_line(dialogue_line, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dialogue_line(%DialogueLine{} = dialogue_line, attrs) do
    dialogue_line
    |> DialogueLine.changeset(attrs)
    |> Repo.update()
  end

  def update_dialogue_line(%DialogueLine{} = dialogue_line, attrs, language_id: language_id) do
    Repo.transaction(fn ->
      {:ok, translation} =
        Dict.create_translation(%{
          "text" => attrs["translation"],
          "language_id" => language_id,
          "phrase_id" => dialogue_line.phrase.id
        })

      {:ok, line} = update_dialogue_line(dialogue_line, attrs)

      line
    end)
    |> notify_dialogue_subscribers(:line_create)
  end

  def update_dialogue_line(%DialogueLine{} = dialogue_line, attrs, translation_id: translation_id) do
    Repo.transaction(fn ->
      {:ok, translation} =
        translation_id
        |> Dict.get_translation!()
        |> Dict.update_translation(%{"text" => attrs["translation"]})

      {:ok, line} = update_dialogue_line(dialogue_line, attrs)

      line
    end)
    |> notify_dialogue_subscribers(:line_create)
  end

  def notify_dialogue_subscribers({:ok, %Dialogue{} = dialogue}, event) do
    topic = "dialogue:#{dialogue.id}"
    Phoenix.PubSub.broadcast(Phrasing.PubSub, topic, {:dialogue_save, :dialogue, event})
    {:ok, dialogue}
  end

  def notify_dialogue_subscribers({:ok, %DialogueLine{} = line}, event) do
    topic = "dialogue:#{line.dialogue_id}"
    Phoenix.PubSub.broadcast(Phrasing.PubSub, topic, {:dialogue_save, event})
    {:ok, line}
  end

  @doc """
  Deletes a dialogue_line.

  ## Examples

      iex> delete_dialogue_line(dialogue_line)
      {:ok, %DialogueLine{}}

      iex> delete_dialogue_line(dialogue_line)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dialogue_line(%DialogueLine{} = dialogue_line) do
    Repo.delete(dialogue_line)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dialogue_line changes.

  ## Examples

      iex> change_dialogue_line(dialogue_line)
      %Ecto.Changeset{source: %DialogueLine{}}

  """
  def change_dialogue_line(%DialogueLine{} = dialogue_line, attrs \\ %{}) do
    DialogueLine.changeset(dialogue_line, attrs)
  end
end
