defmodule Phrasing.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Phrasing.Repo

  alias Phrasing.Accounts.User

  def get_by_email(email) when is_nil(email), do: nil
  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Phrasing.Accounts.UserLanguage

  @doc """
  Returns the list of user_languages.

  ## Examples

      iex> list_user_languages()
      [%UserLanguage{}, ...]

  """
  def list_user_languages do
    Repo.all(UserLanguage)
  end

  @doc """
  Gets a single user_language.

  Raises `Ecto.NoResultsError` if the User language does not exist.

  ## Examples

      iex> get_user_language!(123)
      %UserLanguage{}

      iex> get_user_language!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_language!(id), do: Repo.get!(UserLanguage, id)

  @doc """
  Creates a user_language.

  ## Examples

      iex> create_user_language(%{field: value})
      {:ok, %UserLanguage{}}

      iex> create_user_language(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_language(attrs \\ %{}) do
    %UserLanguage{}
    |> UserLanguage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_language.

  ## Examples

      iex> update_user_language(user_language, %{field: new_value})
      {:ok, %UserLanguage{}}

      iex> update_user_language(user_language, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_language(%UserLanguage{} = user_language, attrs) do
    user_language
    |> UserLanguage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_language.

  ## Examples

      iex> delete_user_language(user_language)
      {:ok, %UserLanguage{}}

      iex> delete_user_language(user_language)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_language(%UserLanguage{} = user_language) do
    Repo.delete(user_language)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_language changes.

  ## Examples

      iex> change_user_language(user_language)
      %Ecto.Changeset{source: %UserLanguage{}}

  """
  def change_user_language(%UserLanguage{} = user_language) do
    UserLanguage.changeset(user_language, %{})
  end

  alias Phrasing.Accounts.Profile

  @doc """
  Returns the list of profiles.

  ## Examples

      iex> list_profiles()
      [%Profile{}, ...]

  """
  def list_profiles do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id), do: Repo.get!(Profile, id)

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{source: %Profile{}}

  """
  def change_profile(%Profile{} = profile) do
    Profile.changeset(profile, %{})
  end
end
