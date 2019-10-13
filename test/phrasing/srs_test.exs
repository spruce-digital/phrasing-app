defmodule Phrasing.SRSTest do
  use Phrasing.DataCase
  use ExUnit.Case
  use ExCheck

  alias Phrasing.SRS
  alias Phrasing.Dict
  alias Phrasing.SRS.Card

  def for_each_score(callback) do
    # IO.inspect Enum.map(0..5, fn s -> callback.(s) end)
    score_failed = Enum.map(0..5, fn s -> callback.(s) end)
      |> Enum.member?(false)

    !score_failed
  end

  def fixture(:phrase) do
    {:ok, phrase} = Dict.create_phrase(%{source: "source", english: "english", lang: "lang"})
    phrase
  end
  def fixture(:card, phrase) do
    {:ok, card} = SRS.create_card(%{id: 1, phrase: phrase})
    card
  end

  describe "card" do
    setup [:setup_card]

    test "create_card/1 with valid data creates a card", %{phrase: phrase, card: card} do
      assert card.phrase_id == phrase.id
    end

    test "score_card/1 with a valid card creates a rep and returns the card", %{card: card} do
      assert card.prev_rep_id > 0

      %{prev_rep: rep} = Repo.preload(card, :prev_rep)

      assert rep.ease == 2.5
      assert rep.due_date == Timex.today
      assert rep.score == nil
      assert rep.card_id == card.id
    end
  end

  describe "score_card" do
    setup [:setup_card]

    test "score a default card 0", %{card: card} do
      {status, next_card} = SRS.score_card card, 0

      assert status == :ok
      assert next_card.prev_rep_id != card.prev_rep_id
      assert next_card.prev_rep.card_id == next_card.id

      next_card = Repo.preload(next_card, [prev_rep: :prev_rep])

      assert next_card.prev_rep.ease < next_card.prev_rep.prev_rep.ease
      assert Timex.diff(next_card.prev_rep.due_date, Timex.today, :days) == 0
    end

    test "score a default card 1", %{card: card} do
      {status, next_card} = SRS.score_card card, 1

      assert status == :ok
      assert next_card.prev_rep_id != card.prev_rep_id
      assert next_card.prev_rep.card_id == next_card.id

      next_card = Repo.preload(next_card, [prev_rep: :prev_rep])

      assert next_card.prev_rep.ease < next_card.prev_rep.prev_rep.ease
      assert Timex.diff(next_card.prev_rep.due_date, Timex.today, :days) == 0
    end

    test "score a default card 2", %{card: card} do
      {status, next_card} = SRS.score_card card, 2

      assert status == :ok
      assert next_card.prev_rep_id != card.prev_rep_id
      assert next_card.prev_rep.card_id == next_card.id

      next_card = Repo.preload(next_card, [prev_rep: :prev_rep])

      assert next_card.prev_rep.ease < next_card.prev_rep.prev_rep.ease
      assert Timex.diff(next_card.prev_rep.due_date, Timex.today, :days) == 0
    end

    test "score a default card 3", %{card: card} do
      {status, next_card} = SRS.score_card card, 3

      assert status == :ok
      assert next_card.prev_rep_id != card.prev_rep_id
      assert next_card.prev_rep.card_id == next_card.id

      next_card = Repo.preload(next_card, [prev_rep: :prev_rep])

      assert next_card.prev_rep.ease < next_card.prev_rep.prev_rep.ease
      assert Timex.diff(next_card.prev_rep.due_date, Timex.today, :days) == 0
    end

    test "score a default card 4", %{card: card} do
      {status, next_card} = SRS.score_card card, 4

      assert status == :ok
      assert next_card.prev_rep_id != card.prev_rep_id
      assert next_card.prev_rep.card_id == next_card.id

      next_card = Repo.preload(next_card, [prev_rep: :prev_rep])

      assert next_card.prev_rep.ease < next_card.prev_rep.prev_rep.ease
      assert Timex.diff(next_card.prev_rep.due_date, Timex.today, :days) > 0
    end

    test "score a default card 5", %{card: card} do
      {status, next_card} = SRS.score_card card, 5

      assert status == :ok
      assert next_card.prev_rep_id != card.prev_rep_id
      assert next_card.prev_rep.card_id == next_card.id

      next_card = Repo.preload(next_card, [prev_rep: :prev_rep])

      assert next_card.prev_rep.ease > next_card.prev_rep.prev_rep.ease
      assert Timex.diff(next_card.prev_rep.due_date, Timex.today, :days) > 0
    end

    test "pass several times then fail", %{card: card} do
      card = Repo.preload(card, :prev_rep)
      assert card.prev_rep.interval == 1
      assert card.prev_rep.iteration == 0
      {status, card} = SRS.score_card card, 4
      assert card.prev_rep.interval == 6
      assert card.prev_rep.iteration == 1
      {status, card} = SRS.score_card card, 4
      assert card.prev_rep.interval == 14
      assert card.prev_rep.iteration == 2
      {status, card} = SRS.score_card card, 4
      assert card.prev_rep.interval == 32
      assert card.prev_rep.iteration == 3
      {status, card} = SRS.score_card card, 3
      assert card.prev_rep.interval == 32
      assert card.prev_rep.iteration == 4
      {status, card} = SRS.score_card card, 4
      assert card.prev_rep.interval == 42
      assert card.prev_rep.iteration == 5
      {status, card} = SRS.score_card card, 2
      assert card.prev_rep.interval == 1
      assert card.prev_rep.iteration == 0
    end
  end

  defp setup_card(_state) do
    phrase = fixture(:phrase)
    card = fixture(:card, phrase)
    {:ok, phrase: phrase, card: card}
  end
end
