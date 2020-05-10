defmodule Phrasing.DictTest do
  use Phrasing.DataCase
  import Phrasing.Factory

  alias Phrasing.{Dict, Translation}

  describe "phrases" do
    test "create_phrase fails with invalid phrase" do
      assert {:error, %Ecto.Changeset{}} = Dict.create_phrase(%{})
    end

    test "create_phrase fails with invalid translations" do
      user = insert(:user)
      attrs = %{
        user_id: insert(:user).id,
        translations: [%{text: "Invalid translation"}]
      }


      assert {:error, %Ecto.Changeset{}} = Dict.create_phrase(attrs)
    end

    test "create_phrase/1 creates an empty phrase" do
      user = insert(:user)
      attrs = %{user_id: user.id}

      assert {:ok, %Dict.Phrase{} = p} = Dict.create_phrase(attrs)
      assert p.user_id == user.id
    end

    test "create_phrase/1 creates a phrase with translations" do
      attrs = %{
        user_id: insert(:user).id,
        translations: [%{language_id: insert(:language).id, text: "Hello"},
                       %{language_id: insert(:language).id, text: "Bonjour"}]
      }

      assert {:ok, %Dict.Phrase{} = p} = Dict.create_phrase(attrs)
      assert Enum.count(p.translations) == 2
    end

    # test "save_phrase/1 creates an empty phrase" do
    #   # TODO: once removing translations is built out
    # end

    # test "save_phrase/1 creates a phrase with it's translations excluding emtpy text" do
    #   attrs = phrase_attrs()

    #   assert {:ok, %Phrase{} = phrase} = Dict.save_phrase(attrs)
    #   assert Enum.all?(phrase.translations, fn t -> t.phrase_id == phrase.id end)
    #   assert Enum.all?(phrase.translations, fn t -> t.id end)
    #   assert Enum.all?(phrase.translations, fn t -> t.text != "" end)
    # end

    # test "save_phrase/1 updates an empty phrase" do
    # end

    # test "save_phrase/1 updates a phrase with it's translations" do
    #   phrase = insert(:phrase)
    #   attrs = phrase_attrs(%{"id" => to_string(phrase.id)})

    #   assert {:ok, %Phrase{} = p} = Dict.save_phrase(attrs)
    #   assert Enum.all?(p.translations, fn t -> t.phrase_id == p.id end)
    #   assert Enum.all?(p.translations, fn t -> t.id end)
    #   assert Enum.all?(p.translations, fn t -> t.text != "" end)
    #   assert Enum.count(p.translations) == 3
    #   assert p.user_id != phrase.user_id
    # end

    # test "save_phrase/1 returns a changeset when there is an invalid translation" do
    #   phrase = insert(:phrase)

    #   attrs =
    #     phrase_attrs()
    #     |> put_in(["translations", "0", "language_id"], "")
    #     |> put_in(["user_id"], "")

    #   assert {:error, %Ecto.Changeset{} = ch} = Dict.save_phrase(attrs)

    #   # TODO: test view error helper

    #   last_phrase = Dict.list_phrases() |> List.first()

    #   assert last_phrase.id == phrase.id
    # end
  end
end
