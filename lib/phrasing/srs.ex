defmodule Phrasing.SRS do
  @moduledoc """
  The SRS module.
  Largely stolen from https://github.com/edubkendo/supermemo/blob/master/lib/supermemo.ex
  """

  import Ecto.Query, warn: false
  alias Phrasing.Repo
  alias Phrasing.Dict
  alias Phrasing.SRS.{Card, Rep}

  @iteration_reset_boundary 3

  def iteration_reset_boundary, do: @iteration_reset_boundary

  def get_card!(id), do: Repo.get(Card, id)

  def list_cards do
    Repo.all(
      from c in Card,
        preload: [:prev_rep, :phrase]
    )
  end

  def list_cards(%Dict.Translation{} = tr, user_id: user_id) do
    Repo.all(
      from c in Card,
        distinct: c.translation_id,
        where: c.user_id == ^user_id,
        where: c.translation_id == ^tr.id
    )
  end

  def list_active_cards(user_id: user_id) do
    Repo.all(
      from c in Card,
        distinct: c.translation_id,
        where: c.user_id == ^user_id,
        left_join: r in assoc(c, :reps),
        group_by: c.id,
        select: {c, count(r.id)},
        preload: [:prev_rep, translation: [:language]]
    )
  end

  def queued_cards(user_id) do
    Repo.all(
      from c in Card,
        distinct: c.translation_id,
        join: r in assoc(c, :prev_rep),
        join: t in assoc(c, :translation),
        where: r.due_date <= ^Timex.today(),
        where: c.user_id == ^user_id,
        where: c.active == true,
        preload: [:prev_rep, translation: [:language, phrase: [:translations]]]
    )
  end

  def learn(translation_id: translation_id, user_id: user_id) do
    tr = Dict.get_translation!(translation_id)

    case list_cards(tr, user_id: user_id) do
      [] ->
        create_card(%{
          "translation_id" => tr.id,
          "user_id" => user_id
        })

      [card] ->
        update_card(card, %{"active" => true})
    end
  end

  def stop_learning(translation_id: translation_id, user_id: user_id) do
    tr = Dict.get_translation!(translation_id)

    case list_cards(tr, user_id: user_id) do
      [] -> {:ok, nil}
      [card] -> update_card(card, %{"active" => false})
    end
  end

  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
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
    |> Repo.insert()
  end

  def create_rep(prev_rep, %{score: score, card_id: card_id}) do
    %Rep{score: score, card_id: card_id}
    |> Rep.score_changeset(prev_rep)
    |> Repo.insert()
  end

  def update_rep(rep, attrs \\ %{}) do
    rep
    |> Rep.changeset(attrs)
    |> Repo.update()
  end

  def score_card({:ok, %Card{} = card}) do
    with {:ok, rep} <- create_rep(%{card_id: card.id}),
         {:ok, card} <- update_card(card, %{prev_rep_id: rep.id}) do
      {:ok, card}
    end
  end

  def score_card(%Card{} = card, score) do
    card = Repo.preload(card, :prev_rep, force: true)

    with {:ok, rep} <- create_rep(card.prev_rep, %Rep{score: score, card_id: card.id}),
         {:ok, card} <- update_card(card, %{prev_rep_id: rep.id}) do
      {:ok, Repo.preload(card, :prev_rep, force: true)}
    else
      {:error, error} -> {:error, error}
    end
  end
end
