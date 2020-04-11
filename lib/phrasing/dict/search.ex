defmodule Phrasing.Dict.Search do
  use StructAccess
  alias __MODULE__

  defstruct text: "", language_id: "", language_text: ""

  def new(params) do
    %Search{
      text: params["text"],
      language_id: params["language_id"],
      language_text: params["language_text"]
    }
  end

  def to_translation_params(%Search{} = search) do
    %{
      "text" => search.text,
      "language_id" => search.language_id,
      "phrase_id" => nil
    }
  end
end
