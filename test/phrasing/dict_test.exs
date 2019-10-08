defmodule Phrasing.DictTest do
  use Phrasing.DataCase

  alias Phrasing.Dict

  describe "phrases" do
    alias Phrasing.Dict.Phrase

    @valid_attrs %{english: "some english", source: "some source"}
    @update_attrs %{english: "some updated english", source: "some updated source"}
    @invalid_attrs %{english: nil, source: nil}

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
end
