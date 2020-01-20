defmodule Phrasing.Factory do
  use ExMachina.Ecto, repo: Phrasing.Repo

  def user_factory do
    %Phrasing.Accounts.User{
      email: sequence(:email, &"factory_#{&1}@worker.com"),
      encrypted_password: "foo",
    }
  end

  def english_language_factory do
    %Phrasing.Dict.Language{
      code: "en",
      name: "english",
    }
  end

  def language_factory do
    %Phrasing.Dict.Language{
      code: sequence(:code, &"ln #{&1}"),
      name: sequence(:name, &"Language #{&1}"),
    }
  end

  def source_translation_factory do
    %Phrasing.Dict.Translation{
      source: true,
      text: sequence(:text, &"source translation #{&1}"),
      script: "latin",
      language: build(:english_language),
    }
  end

  def foreign_translation_factory do
    %Phrasing.Dict.Translation{
      source: false,
      text: sequence(:text, &"foreign translation #{&1}"),
      script: "latin",
      language: build(:language),
    }
  end

  def empty_phrase_factory do
    %Phrasing.Dict.Phrase{
      user: build(:user),
    }
  end

  def phrase_factory do
    %Phrasing.Dict.Phrase{
      user: build(:user),
      translations: [build(:source_translation), build(:foreign_translation)],
    }
  end
end
