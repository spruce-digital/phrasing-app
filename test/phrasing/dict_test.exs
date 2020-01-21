defmodule Phrasing.DictTest do
  use Phrasing.DataCase

  import Phrasing.Factory

  alias Phrasing.Dict

  describe "phrases" do
    alias Phrasing.Dict.Phrase

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{user_id: nil}

    def phrase_fixture(attrs \\ %{}) do
      user = insert(:user)

      {:ok, phrase} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{user_id: user.id})
        |> Dict.create_phrase()

      phrase
    end

    def phrase_attrs(opts \\ %{}) do
      user = insert(:user)
      [en, fr] = insert_pair(:language)

      attrs = %{
        "id" => "",
        "translations" => %{
          "0" => %{"language_id" => to_string(en.id), "text" => "hello"},
          "1" => %{"language_id" => to_string(fr.id), "text" => "Bonjour"},
          "2" => %{"language_id" => to_string(en.id), "text" => "Hi"},
          "3" => %{"text" => ""}
        },
        "user_id" => to_string(user.id)
      }

      Map.merge(attrs, opts)
    end

    test "save_phrase/1 creates an empty phrase" do
      # TODO: once removing translations is built out
    end

    test "save_phrase/1 creates a phrase with it's translations excluding emtpy text" do
      attrs = phrase_attrs()

      assert {:ok, %Phrase{} = phrase} = Dict.save_phrase(attrs)
      assert Enum.all?(phrase.translations, fn t -> t.phrase_id == phrase.id end)
      assert Enum.all?(phrase.translations, fn t -> t.id end)
      assert Enum.all?(phrase.translations, fn t -> t.text != "" end)
    end

    test "save_phrase/1 updates an empty phrase" do
    end

    test "save_phrase/1 updates a phrase with it's translations" do
      phrase = insert(:phrase)
      attrs = phrase_attrs(%{"id" => to_string(phrase.id)})

      assert {:ok, %Phrase{} = p} = Dict.save_phrase(attrs)
      assert Enum.all?(p.translations, fn t -> t.phrase_id == p.id end)
      assert Enum.all?(p.translations, fn t -> t.id end)
      assert Enum.all?(p.translations, fn t -> t.text != "" end)
      assert Enum.count(p.translations) == 3
      assert p.user_id != phrase.user_id
    end

    test "save_phrase/1 returns a changeset when there is an invalid translation" do
      phrase = insert(:phrase)

      attrs =
        phrase_attrs()
        |> put_in(["translations", "0", "language_id"], "")
        |> put_in(["user_id"], "")

      assert {:error, %Ecto.Changeset{} = ch} = Dict.save_phrase(attrs)

      # TODO: test view error helper

      last_phrase = Dict.list_phrases() |> List.first()

      assert last_phrase.id == phrase.id
    end

    # GENERATED

    test "list_phrases/0 returns all phrases" do
      phrase = insert(:phrase)
      assert Dict.list_phrases() |> Enum.map(& &1.id) == [phrase.id]
    end

    test "get_phrase!/1 returns the phrase with given id" do
      phrase = insert(:phrase)
      assert Dict.get_phrase!(phrase.id).id == phrase.id
    end

    test "create_phrase/1 with valid data creates a phrase" do
      user = insert(:user)

      assert {:ok, %Phrase{} = phrase} =
               @valid_attrs
               |> Enum.into(%{user_id: user.id})
               |> Dict.create_phrase()
    end

    test "create_phrase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dict.create_phrase(@invalid_attrs)
    end

    test "update_phrase/2 with valid data updates the phrase" do
      phrase = phrase_fixture()
      assert {:ok, %Phrase{} = phrase} = Dict.update_phrase(phrase, @update_attrs)
    end

    test "update_phrase/2 with invalid data returns error changeset" do
      phrase = phrase_fixture()
      assert {:error, %Ecto.Changeset{}} = Dict.update_phrase(phrase, @invalid_attrs)
      assert phrase == Dict.get_phrase!(phrase.id)
    end

    test "delete_phrase/1 deletes the phrase" do
      phrase = phrase_fixture()
      assert {:ok, %Phrase{}} = Dict.delete_phrase(phrase)
      assert_raise Ecto.NoResultsError, fn -> Dict.get_phrase!(phrase.id) end
    end

    test "change_phrase/1 returns a phrase changeset" do
      phrase = phrase_fixture()
      assert %Ecto.Changeset{} = Dict.change_phrase(phrase)
    end

    test "create_or_update_phrase/1 creates a phrase" do
      user = insert(:user)
      assert {:ok, %Phrase{} = phrase} = Dict.create_or_update_phrase(%{user_id: user.id})
    end

    test "create_or_update_phrase/1 updates a phrase" do
      user = insert(:user)
      phrase = insert(:empty_phrase)
      params = %{id: phrase.id, user_id: user.id}

      assert {:ok, %Phrase{} = phrase} = Dict.create_or_update_phrase(params)
      assert phrase.user_id == user.id
    end

    test "create_or_update_phrase/2 will associate translations" do
      phrase = insert(:empty_phrase)
      language = insert(:language)

      translations = [
        %{"text" => "text", "source" => true, "language_id" => language.id, "script" => "latin"}
      ]

      assert {:ok, %Phrase{} = phrase} =
               Dict.create_or_update_phrase(%{id: phrase.id}, translations)
    end
  end

  describe "entries" do
    alias Phrasing.Dict.Entry

    @valid_attrs %{root: "some root", tags: %{}}
    @update_attrs %{root: "some updated root", tags: %{}}
    @invalid_attrs %{root: nil, tags: nil}

    def entry_fixture(attrs \\ %{}) do
      {:ok, entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dict.create_entry()

      entry
    end

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Dict.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Dict.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      assert {:ok, %Entry{} = entry} = Dict.create_entry(@valid_attrs)
      assert entry.root == "some root"
      assert entry.tags == %{}
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dict.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{} = entry} = Dict.update_entry(entry, @update_attrs)
      assert entry.root == "some updated root"
      assert entry.tags == %{}
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Dict.update_entry(entry, @invalid_attrs)
      assert entry == Dict.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Dict.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Dict.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Dict.change_entry(entry)
    end
  end

  describe "languages" do
    alias Phrasing.Dict.Language

    @valid_attrs %{code: "some code", name: "some name"}
    @update_attrs %{code: "some updated code", name: "some updated name"}
    @invalid_attrs %{code: nil, name: nil}

    def language_fixture(attrs \\ %{}) do
      {:ok, language} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dict.create_language()

      language
    end

    test "list_languages/0 returns all languages" do
      language = language_fixture()
      assert Dict.list_languages() == [language]
    end

    test "get_language!/1 returns the language with given id" do
      language = language_fixture()
      assert Dict.get_language!(language.id) == language
    end

    test "create_language/1 with valid data creates a language" do
      assert {:ok, %Language{} = language} = Dict.create_language(@valid_attrs)
      assert language.code == "some code"
      assert language.name == "some name"
    end

    test "create_language/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dict.create_language(@invalid_attrs)
    end

    test "update_language/2 with valid data updates the language" do
      language = language_fixture()
      assert {:ok, %Language{} = language} = Dict.update_language(language, @update_attrs)
      assert language.code == "some updated code"
      assert language.name == "some updated name"
    end

    test "update_language/2 with invalid data returns error changeset" do
      language = language_fixture()
      assert {:error, %Ecto.Changeset{}} = Dict.update_language(language, @invalid_attrs)
      assert language == Dict.get_language!(language.id)
    end

    test "delete_language/1 deletes the language" do
      language = language_fixture()
      assert {:ok, %Language{}} = Dict.delete_language(language)
      assert_raise Ecto.NoResultsError, fn -> Dict.get_language!(language.id) end
    end

    test "change_language/1 returns a language changeset" do
      language = language_fixture()
      assert %Ecto.Changeset{} = Dict.change_language(language)
    end
  end

  describe "translations" do
    alias Phrasing.Dict.Translation

    @valid_attrs %{source: true, text: "some text"}
    @update_attrs %{source: false, text: "some updated text"}
    @invalid_attrs %{source: nil, text: nil}

    def translation_fixture(attrs \\ %{}) do
      language = insert(:language)
      phrase = insert(:phrase)

      {:ok, translation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{language_id: language.id, phrase_id: phrase.id})
        |> Dict.create_translation()

      translation
    end

    test "list_translations/0 returns all translations" do
      phrase = insert(:phrase)
      assert Dict.list_translations() |> Repo.preload(:language) == phrase.translations
    end

    test "get_translation!/1 returns the translation with given id" do
      translation = translation_fixture()
      assert Dict.get_translation!(translation.id) == translation
    end

    test "create_translation/1 with valid data creates a translation" do
      language = insert(:language)
      phrase = insert(:phrase)

      assert {:ok, %Translation{} = translation} =
               @valid_attrs
               |> Enum.into(%{language_id: language.id, phrase_id: phrase.id})
               |> Dict.create_translation()

      assert translation.source == true
      assert translation.text == "some text"
    end

    test "create_translation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dict.create_translation(@invalid_attrs)
    end

    test "update_translation/2 with valid data updates the translation" do
      translation = translation_fixture()

      assert {:ok, %Translation{} = translation} =
               Dict.update_translation(translation, @update_attrs)

      assert translation.source == false
      assert translation.text == "some updated text"
    end

    test "update_translation/2 with invalid data returns error changeset" do
      translation = translation_fixture()
      assert {:error, %Ecto.Changeset{}} = Dict.update_translation(translation, @invalid_attrs)
      assert translation == Dict.get_translation!(translation.id)
    end

    test "delete_translation/1 deletes the translation" do
      translation = translation_fixture()
      assert {:ok, %Translation{}} = Dict.delete_translation(translation)
      assert_raise Ecto.NoResultsError, fn -> Dict.get_translation!(translation.id) end
    end

    test "change_translation/1 returns a translation changeset" do
      translation = translation_fixture()
      assert %Ecto.Changeset{} = Dict.change_translation(translation)
    end
  end
end
