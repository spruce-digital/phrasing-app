defmodule PhrasingWeb.PhraseControllerTest do
  use PhrasingWeb.ConnCase

  alias Phrasing.Dict

  # @create_attrs %{english: "some english", source: "some source", lang: "some lang"}
  # @update_attrs %{english: "some updated english", source: "some updated source", lang: "some updated lang"}
  # @invalid_attrs %{english: nil, source: nil}

  # def fixture(:phrase) do
  #   {:ok, phrase} = Dict.create_phrase(@create_attrs)
  #   phrase
  # end

  describe "index" do
    # test "lists all phrases", %{conn: conn} do
    #   conn = get(conn, Routes.phrase_path(conn, :index))
    #   assert html_response(conn, 200) =~ "Listing Phrases"
    # end
  end

  describe "new phrase" do
    # test "renders form", %{conn: conn} do
    #   conn = get(conn, Routes.phrase_path(conn, :new))
    #   assert html_response(conn, 200) =~ "New Phrase"
    # end
  end

  describe "create phrase" do
    # test "redirects to show when data is valid", %{conn: conn} do
    #   conn = post(conn, Routes.phrase_path(conn, :create), phrase: @create_attrs)

    #   assert %{id: id} = redirected_params(conn)
    #   assert redirected_to(conn) == Routes.phrase_path(conn, :show, id)

    #   conn = get(conn, Routes.phrase_path(conn, :show, id))
    #   assert html_response(conn, 200) =~ "Show Phrase"
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, Routes.phrase_path(conn, :create), phrase: @invalid_attrs)
    #   assert html_response(conn, 200) =~ "New Phrase"
    # end
  end

  describe "edit phrase" do
    # setup [:create_phrase]

    # test "renders form for editing chosen phrase", %{conn: conn, phrase: phrase} do
    #   conn = get(conn, Routes.phrase_path(conn, :edit, phrase))
    #   assert html_response(conn, 200) =~ "Edit Phrase"
    # end
  end

  describe "update phrase" do
    # setup [:create_phrase]

    # test "redirects when data is valid", %{conn: conn, phrase: phrase} do
    #   conn = put(conn, Routes.phrase_path(conn, :update, phrase), phrase: @update_attrs)
    #   assert redirected_to(conn) == Routes.phrase_path(conn, :show, phrase)

    #   conn = get(conn, Routes.phrase_path(conn, :show, phrase))
    #   assert html_response(conn, 200) =~ "some updated english"
    # end

    # test "renders errors when data is invalid", %{conn: conn, phrase: phrase} do
    #   conn = put(conn, Routes.phrase_path(conn, :update, phrase), phrase: @invalid_attrs)
    #   assert html_response(conn, 200) =~ "Edit Phrase"
    # end
  end

  describe "delete phrase" do
    # setup [:create_phrase]

    # test "deletes chosen phrase", %{conn: conn, phrase: phrase} do
    #   conn = delete(conn, Routes.phrase_path(conn, :delete, phrase))
    #   assert redirected_to(conn) == Routes.phrase_path(conn, :index)
    #   assert_error_sent 404, fn ->
    #     get(conn, Routes.phrase_path(conn, :show, phrase))
    #   end
    # end
  end

  # defp create_phrase(_) do
  #   phrase = fixture(:phrase)
  #   {:ok, phrase: phrase}
  # end
end
