defmodule Phrasing.SRS do
  @moduledoc """
  The SRS module.
  Largely stolen from https://github.com/edubkendo/supermemo/blob/master/lib/supermemo.ex
  """

  import Ecto.Query, warn: false
  alias Phrasing.Repo
  alias Phrasing.SRS.Card

  @default_ease 2.5
  @min_ease 1.3
  @first_interval 1
  @second_interval 6
  @iteration_reset_boundary 3
  @repeat_boundary 4


  def list_available_cards do
  end

  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

end
