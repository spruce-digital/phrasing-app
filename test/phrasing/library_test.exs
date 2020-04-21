defmodule Phrasing.LibraryTest do
  use Phrasing.DataCase

  alias Phrasing.Library

  describe "dialogues" do
    alias Phrasing.Library.Dialogue

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def dialogue_fixture(attrs \\ %{}) do
      {:ok, dialogue} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Library.create_dialogue()

      dialogue
    end

    test "list_dialogues/0 returns all dialogues" do
      dialogue = dialogue_fixture()
      assert Library.list_dialogues() == [dialogue]
    end

    test "get_dialogue!/1 returns the dialogue with given id" do
      dialogue = dialogue_fixture()
      assert Library.get_dialogue!(dialogue.id) == dialogue
    end

    test "create_dialogue/1 with valid data creates a dialogue" do
      assert {:ok, %Dialogue{} = dialogue} = Library.create_dialogue(@valid_attrs)
      assert dialogue.title == "some title"
    end

    test "create_dialogue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_dialogue(@invalid_attrs)
    end

    test "update_dialogue/2 with valid data updates the dialogue" do
      dialogue = dialogue_fixture()
      assert {:ok, %Dialogue{} = dialogue} = Library.update_dialogue(dialogue, @update_attrs)
      assert dialogue.title == "some updated title"
    end

    test "update_dialogue/2 with invalid data returns error changeset" do
      dialogue = dialogue_fixture()
      assert {:error, %Ecto.Changeset{}} = Library.update_dialogue(dialogue, @invalid_attrs)
      assert dialogue == Library.get_dialogue!(dialogue.id)
    end

    test "delete_dialogue/1 deletes the dialogue" do
      dialogue = dialogue_fixture()
      assert {:ok, %Dialogue{}} = Library.delete_dialogue(dialogue)
      assert_raise Ecto.NoResultsError, fn -> Library.get_dialogue!(dialogue.id) end
    end

    test "change_dialogue/1 returns a dialogue changeset" do
      dialogue = dialogue_fixture()
      assert %Ecto.Changeset{} = Library.change_dialogue(dialogue)
    end
  end

  describe "dialogue_lines" do
    alias Phrasing.Library.DialogueLine

    @valid_attrs %{position: 42}
    @update_attrs %{position: 43}
    @invalid_attrs %{position: nil}

    def dialogue_line_fixture(attrs \\ %{}) do
      {:ok, dialogue_line} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Library.create_dialogue_line()

      dialogue_line
    end

    test "list_dialogue_lines/0 returns all dialogue_lines" do
      dialogue_line = dialogue_line_fixture()
      assert Library.list_dialogue_lines() == [dialogue_line]
    end

    test "get_dialogue_line!/1 returns the dialogue_line with given id" do
      dialogue_line = dialogue_line_fixture()
      assert Library.get_dialogue_line!(dialogue_line.id) == dialogue_line
    end

    test "create_dialogue_line/1 with valid data creates a dialogue_line" do
      assert {:ok, %DialogueLine{} = dialogue_line} = Library.create_dialogue_line(@valid_attrs)
      assert dialogue_line.position == 42
    end

    test "create_dialogue_line/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_dialogue_line(@invalid_attrs)
    end

    test "update_dialogue_line/2 with valid data updates the dialogue_line" do
      dialogue_line = dialogue_line_fixture()
      assert {:ok, %DialogueLine{} = dialogue_line} = Library.update_dialogue_line(dialogue_line, @update_attrs)
      assert dialogue_line.position == 43
    end

    test "update_dialogue_line/2 with invalid data returns error changeset" do
      dialogue_line = dialogue_line_fixture()
      assert {:error, %Ecto.Changeset{}} = Library.update_dialogue_line(dialogue_line, @invalid_attrs)
      assert dialogue_line == Library.get_dialogue_line!(dialogue_line.id)
    end

    test "delete_dialogue_line/1 deletes the dialogue_line" do
      dialogue_line = dialogue_line_fixture()
      assert {:ok, %DialogueLine{}} = Library.delete_dialogue_line(dialogue_line)
      assert_raise Ecto.NoResultsError, fn -> Library.get_dialogue_line!(dialogue_line.id) end
    end

    test "change_dialogue_line/1 returns a dialogue_line changeset" do
      dialogue_line = dialogue_line_fixture()
      assert %Ecto.Changeset{} = Library.change_dialogue_line(dialogue_line)
    end
  end
end
