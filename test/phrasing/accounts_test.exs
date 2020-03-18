defmodule Phrasing.AccountsTest do
  use Phrasing.DataCase

  alias Phrasing.Accounts

  describe "users" do
    alias Phrasing.Accounts.User

    @valid_attrs %{email: "some email", encrypted_password: "some encrypted_password"}
    @update_attrs %{email: "some updated email", encrypted_password: "some updated encrypted_password"}
    @invalid_attrs %{email: nil, encrypted_password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.encrypted_password != "some encrypted_password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.encrypted_password != "some updated encrypted_password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "user_languages" do
    alias Phrasing.Accounts.UserLanguage

    @valid_attrs %{level: 42}
    @update_attrs %{level: 43}
    @invalid_attrs %{level: nil}

    def user_language_fixture(attrs \\ %{}) do
      {:ok, user_language} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_language()

      user_language
    end

    test "list_user_languages/0 returns all user_languages" do
      user_language = user_language_fixture()
      assert Accounts.list_user_languages() == [user_language]
    end

    test "get_user_language!/1 returns the user_language with given id" do
      user_language = user_language_fixture()
      assert Accounts.get_user_language!(user_language.id) == user_language
    end

    test "create_user_language/1 with valid data creates a user_language" do
      assert {:ok, %UserLanguage{} = user_language} = Accounts.create_user_language(@valid_attrs)
      assert user_language.level == 42
    end

    test "create_user_language/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_language(@invalid_attrs)
    end

    test "update_user_language/2 with valid data updates the user_language" do
      user_language = user_language_fixture()
      assert {:ok, %UserLanguage{} = user_language} = Accounts.update_user_language(user_language, @update_attrs)
      assert user_language.level == 43
    end

    test "update_user_language/2 with invalid data returns error changeset" do
      user_language = user_language_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_language(user_language, @invalid_attrs)
      assert user_language == Accounts.get_user_language!(user_language.id)
    end

    test "delete_user_language/1 deletes the user_language" do
      user_language = user_language_fixture()
      assert {:ok, %UserLanguage{}} = Accounts.delete_user_language(user_language)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_language!(user_language.id) end
    end

    test "change_user_language/1 returns a user_language changeset" do
      user_language = user_language_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_language(user_language)
    end
  end

  describe "profiles" do
    alias Phrasing.Accounts.Profile

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def profile_fixture(attrs \\ %{}) do
      {:ok, profile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_profile()

      profile
    end

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert Accounts.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Accounts.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      assert {:ok, %Profile{} = profile} = Accounts.create_profile(@valid_attrs)
      assert profile.name == "some name"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{} = profile} = Accounts.update_profile(profile, @update_attrs)
      assert profile.name == "some updated name"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_profile(profile, @invalid_attrs)
      assert profile == Accounts.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Accounts.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Accounts.change_profile(profile)
    end
  end
end
