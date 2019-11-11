defmodule Phrasing.LibraryTest do
  use Phrasing.DataCase

  alias Phrasing.Library

  describe "journal" do
    alias Phrasing.Library.Journal

    @valid_attrs %{body: "some body", lang: "some lang"}
    @update_attrs %{body: "some updated body", lang: "some updated lang"}
    @invalid_attrs %{body: nil, lang: nil}

    def journal_fixture(attrs \\ %{}) do
      {:ok, journal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Library.create_journal()

      journal
    end

    test "list_journal/0 returns all journal" do
      journal = journal_fixture()
      assert Library.list_journal() == [journal]
    end

    test "get_journal!/1 returns the journal with given id" do
      journal = journal_fixture()
      assert Library.get_journal!(journal.id) == journal
    end

    test "create_journal/1 with valid data creates a journal" do
      assert {:ok, %Journal{} = journal} = Library.create_journal(@valid_attrs)
      assert journal.body == "some body"
      assert journal.lang == "some lang"
    end

    test "create_journal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_journal(@invalid_attrs)
    end

    test "update_journal/2 with valid data updates the journal" do
      journal = journal_fixture()
      assert {:ok, %Journal{} = journal} = Library.update_journal(journal, @update_attrs)
      assert journal.body == "some updated body"
      assert journal.lang == "some updated lang"
    end

    test "update_journal/2 with invalid data returns error changeset" do
      journal = journal_fixture()
      assert {:error, %Ecto.Changeset{}} = Library.update_journal(journal, @invalid_attrs)
      assert journal == Library.get_journal!(journal.id)
    end

    test "delete_journal/1 deletes the journal" do
      journal = journal_fixture()
      assert {:ok, %Journal{}} = Library.delete_journal(journal)
      assert_raise Ecto.NoResultsError, fn -> Library.get_journal!(journal.id) end
    end

    test "change_journal/1 returns a journal changeset" do
      journal = journal_fixture()
      assert %Ecto.Changeset{} = Library.change_journal(journal)
    end
  end

  describe "songs" do
    alias Phrasing.Library.Song

    @valid_attrs %{body: "some body", lang: "some lang", url: "some url"}
    @update_attrs %{body: "some updated body", lang: "some updated lang", url: "some updated url"}
    @invalid_attrs %{body: nil, lang: nil, url: nil}

    def song_fixture(attrs \\ %{}) do
      {:ok, song} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Library.create_song()

      song
    end

    test "list_songs/0 returns all songs" do
      song = song_fixture()
      assert Library.list_songs() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture()
      assert Library.get_song!(song.id) == song
    end

    test "create_song/1 with valid data creates a song" do
      assert {:ok, %Song{} = song} = Library.create_song(@valid_attrs)
      assert song.body == "some body"
      assert song.lang == "some lang"
      assert song.url == "some url"
    end

    test "create_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_song(@invalid_attrs)
    end

    test "update_song/2 with valid data updates the song" do
      song = song_fixture()
      assert {:ok, %Song{} = song} = Library.update_song(song, @update_attrs)
      assert song.body == "some updated body"
      assert song.lang == "some updated lang"
      assert song.url == "some updated url"
    end

    test "update_song/2 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = Library.update_song(song, @invalid_attrs)
      assert song == Library.get_song!(song.id)
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{}} = Library.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> Library.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Library.change_song(song)
    end
  end

  describe "books" do
    alias Phrasing.Library.Book

    @valid_attrs %{body: "some body", lang: "some lang", title: "some title"}
    @update_attrs %{body: "some updated body", lang: "some updated lang", title: "some updated title"}
    @invalid_attrs %{body: nil, lang: nil, title: nil}

    def book_fixture(attrs \\ %{}) do
      {:ok, book} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Library.create_book()

      book
    end

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Library.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Library.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      assert {:ok, %Book{} = book} = Library.create_book(@valid_attrs)
      assert book.body == "some body"
      assert book.lang == "some lang"
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      assert {:ok, %Book{} = book} = Library.update_book(book, @update_attrs)
      assert book.body == "some updated body"
      assert book.lang == "some updated lang"
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Library.update_book(book, @invalid_attrs)
      assert book == Library.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Library.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Library.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Library.change_book(book)
    end
  end

  describe "chapters" do
    alias Phrasing.Library.Chapter

    @valid_attrs %{body: %{}}
    @update_attrs %{body: %{}}
    @invalid_attrs %{body: nil}

    def chapter_fixture(attrs \\ %{}) do
      {:ok, chapter} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Library.create_chapter()

      chapter
    end

    test "list_chapters/0 returns all chapters" do
      chapter = chapter_fixture()
      assert Library.list_chapters() == [chapter]
    end

    test "get_chapter!/1 returns the chapter with given id" do
      chapter = chapter_fixture()
      assert Library.get_chapter!(chapter.id) == chapter
    end

    test "create_chapter/1 with valid data creates a chapter" do
      assert {:ok, %Chapter{} = chapter} = Library.create_chapter(@valid_attrs)
      assert chapter.body == %{}
    end

    test "create_chapter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_chapter(@invalid_attrs)
    end

    test "update_chapter/2 with valid data updates the chapter" do
      chapter = chapter_fixture()
      assert {:ok, %Chapter{} = chapter} = Library.update_chapter(chapter, @update_attrs)
      assert chapter.body == %{}
    end

    test "update_chapter/2 with invalid data returns error changeset" do
      chapter = chapter_fixture()
      assert {:error, %Ecto.Changeset{}} = Library.update_chapter(chapter, @invalid_attrs)
      assert chapter == Library.get_chapter!(chapter.id)
    end

    test "delete_chapter/1 deletes the chapter" do
      chapter = chapter_fixture()
      assert {:ok, %Chapter{}} = Library.delete_chapter(chapter)
      assert_raise Ecto.NoResultsError, fn -> Library.get_chapter!(chapter.id) end
    end

    test "change_chapter/1 returns a chapter changeset" do
      chapter = chapter_fixture()
      assert %Ecto.Changeset{} = Library.change_chapter(chapter)
    end
  end
end
