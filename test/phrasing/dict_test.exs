defmodule Phrasing.DictTest do
  use Phrasing.DataCase

  alias Phrasing.Dict

  describe "phrases" do
    alias Phrasing.Dict.Phrase

    @valid_attrs %{english: "some english", source: "some source", lang: "some lang"}
    @update_attrs %{english: "some updated english", source: "some updated source", lang: "some updated lang"}
    @invalid_attrs %{english: nil, source: nil, lang: nil}

    def phrase_fixture(attrs \\ %{}) do
      {:ok, phrase} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dict.create_phrase()

      phrase
    end

    test "list_phrases/0 returns all phrases" do
      phrase = phrase_fixture()
      assert Dict.list_phrases() == [phrase]
    end

    test "get_phrase!/1 returns the phrase with given id" do
      phrase = phrase_fixture()
      assert Dict.get_phrase!(phrase.id) == phrase
    end

    test "create_phrase/1 with valid data creates a phrase" do
      assert {:ok, %Phrase{} = phrase} = Dict.create_phrase(@valid_attrs)
      assert phrase.english == "some english"
      assert phrase.source == "some source"
    end

    test "create_phrase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dict.create_phrase(@invalid_attrs)
    end

    test "update_phrase/2 with valid data updates the phrase" do
      phrase = phrase_fixture()
      assert {:ok, %Phrase{} = phrase} = Dict.update_phrase(phrase, @update_attrs)
      assert phrase.english == "some updated english"
      assert phrase.source == "some updated source"
      assert phrase.lang == "some updated lang"
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
end
