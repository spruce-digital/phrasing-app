defmodule Phrasing.SRS do
  @moduledoc """
  The SRS module.
  Largely stolen from https://github.com/edubkendo/supermemo/blob/master/lib/supermemo.ex
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias Phrasing.Repo
  alias Phrasing.SRS.{Card,Rep}

  @iteration_reset_boundary 3

  def iteration_reset_boundary, do: @iteration_reset_boundary

  def get_card!(id), do: Repo.get(Card, id)

  def list_cards do
    Repo.all from c in Card,
      preload: [:prev_rep, :phrase]
  end

  def list_active_cards do
    Repo.all from c in Card,
      distinct: c.phrase_id,
      preload: [:prev_rep, :phrase]
  end

  def queued_cards() do
    Repo.all from c in Card,
      distinct: c.phrase_id,
      join: r in assoc(c, :prev_rep),
      where: r.due_date <= ^Timex.today(),
      preload: [:prev_rep, :phrase]
  end

  def create_card(attrs \\ %{}) do
    {phrase, attrs} = Map.pop(attrs, :phrase)

    IO.inspect attrs

    phrase
    |> Ecto.build_assoc(:cards)
    |> Card.changeset(attrs)
    |> Repo.insert
    |> score_card
  end

  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  def create_rep(attrs \\ %{}) do
    %Rep{}
    |> Rep.changeset(attrs)
    |> Repo.insert
  end
  def create_rep(prev_rep, %{score: score, card_id: card_id}) do
    %Rep{score: score, card_id: card_id}
    |> Rep.score_changeset(prev_rep)
    |> Repo.insert
  end

  def update_rep(rep, attrs \\ %{}) do
    rep
    |> Rep.changeset(attrs)
    |> Repo.update
  end

  def score_card({:ok, %Card{} = card}) do
    with {:ok, rep}  <- create_rep(%{card_id: card.id}),
         {:ok, card} <- update_card(card, %{prev_rep_id: rep.id}) do
      {:ok, card}
    end
  end
  def score_card(%Card{} = card, score) do
    card = Repo.preload card, :prev_rep, force: true

    with {:ok, rep}  <- create_rep(card.prev_rep, %Rep{score: score, card_id: card.id}),
         {:ok, card} <- update_card(card, %{prev_rep_id: rep.id}) do
      {:ok, Repo.preload(card, :prev_rep, force: true)}
    else
      {:error, error} -> {:error, error}
    end
  end

end
