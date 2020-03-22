defmodule PhrasingWeb.Helpers.LanguageLevelTest do
  use ExUnit.Case, async: true

  alias PhrasingWeb.Helpers.LanguageLevel
  alias Phrasing.Accounts.UserLanguage

  @user_id 1

  describe "to user languages" do
    test "it adds a learning language at level 0" do
      params = %{"1" => %{"learning" => "on"}}
      result = [%{"user_id" => @user_id, "language_id" => "1", "level" => "0"}]

      assert LanguageLevel.to_user_languages(params, user_id: @user_id) == result
    end

    test "it adds a native language at level 100" do
      params = %{"1" => %{"native" => "on"}}
      result = [%{"user_id" => @user_id, "language_id" => "1", "level" => "100"}]

      assert LanguageLevel.to_user_languages(params, user_id: @user_id) == result
    end

    test "it ignores off properties" do
      params = %{"1" => %{"learning" => "off"}}
      result = []

      assert LanguageLevel.to_user_languages(params, user_id: @user_id) == result

      params = %{"1" => %{"native" => "off"}}
      result = []

      assert LanguageLevel.to_user_languages(params, user_id: @user_id) == result
    end

    test "it prioritizes native over learning" do
      params = %{"1" => %{"native" => "on", "learning" => "on"}}
      result = [%{"user_id" => @user_id, "language_id" => "1", "level" => "100"}]

      assert LanguageLevel.to_user_languages(params, user_id: @user_id) == result
    end

    test "it handles multiple languages" do
      params = %{
        "1" => %{"learning" => "on"},
        "2" => %{"native" => "on"},
        "3" => %{"learning" => "on"},
        "4" => %{"native" => "off"},
        "5" => %{"native" => "off", "learning" => "off"}
      }

      result = [
        %{"user_id" => @user_id, "language_id" => "1", "level" => "0"},
        %{"user_id" => @user_id, "language_id" => "2", "level" => "100"},
        %{"user_id" => @user_id, "language_id" => "3", "level" => "0"}
      ]

      assert LanguageLevel.to_user_languages(params, user_id: @user_id) == result
    end
  end
end
