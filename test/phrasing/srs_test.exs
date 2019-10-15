defmodule Phrasing.SRSTest do
  use Phrasing.DataCase
  use ExUnit.Case
  use ExCheck
  import Ecto.Query, warn: false

  alias Phrasing.SRS
  alias Phrasing.Dict

  def for_each_score(callback) do
    # IO.inspect Enum.map(0..5, fn s -> callback.(s) end)
    score_failed = Enum.map(0..5, fn s -> callback.(s) end)
      |> Enum.member?(false)

    !score_failed
  end

  def score_card_all(card) do
    Enum.reduce 0..5, [], fn (score, acc) ->
      [SRS.score_card(card, score) | acc]
    end
  end

  def score_card_multi(card, scores) do
    Enum.reduce scores, {:ok, card}, fn (score, {_, card}) ->
      SRS.score_card card, score
    end
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

    test "scoring card creates new rep", %{card: card} do
      cards = score_card_all card

      Enum.each cards, fn {status, c} ->
        assert status == :ok
        assert c.prev_rep_id != card.prev_rep_id
      end
    end

    test "scoring card preserves card_id", %{card: card} do
      cards = score_card_all card

      Enum.each cards, fn {status, c} ->
        assert status == :ok
        assert c.prev_rep.card_id == card.id
      end
    end

    test "ease does not change for first iteration", %{card: card} do
      cards = score_card_all card

      Enum.each cards, fn {status, c} ->
        assert status == :ok
        assert c.prev_rep.ease == 2.5
      end
    end

    test "ease does not change for second iteration", %{card: card} do
      {_status, card} = SRS.score_card card, 3
      cards = score_card_all card

      Enum.each cards, fn {status, c} ->
        assert status == :ok
        assert c.prev_rep.ease == 2.5
      end
    end

    test "scoring below 4 repeats today", %{card: card} do
      cards = score_card_all card

      Enum.each cards, fn {status, c} ->
        assert status == :ok

        if c.prev_rep.score < 4 do
          assert c.prev_rep.due_date == Timex.today
        end
      end
    end

    test "scoring 4 does not change ease", %{card: card} do
      {status, card} = score_card_multi card, [4,4,4,4,4,4,4,4,4,4]

      assert status == :ok
      assert card.prev_rep.ease == 2.5
    end

    test "scoring 3 repeats today and changes ease but does not change interval", %{card: card} do
      {:ok, card} = score_card_multi card, [5,5,5,5,5]
      {:ok, card_3} = score_card_multi card, [3,3,3,3,3]

      assert card_3.prev_rep.due_date == Timex.today
      assert card_3.prev_rep.interval == card.prev_rep.interval
      assert card_3.prev_rep.ease     != card.prev_rep.ease
    end

    test "first pass of card is always scheduled for tomorrow", %{card: card} do
      {:ok, card} = score_card_multi card, [0,0,0,0,0,5]

      assert card.prev_rep.due_date == Timex.shift(Timex.today, days: 1)
    end
  end

  describe "queued_cards" do
    setup [:setup_card]

    test "gets all cards due today", %{card: card} do
      card = Repo.preload card, :prev_rep
      queued_cards = SRS.queued_cards()

      assert Enum.any? queued_cards, fn c ->
        c.prev_rep == card.prev_rep
      end
    end

    test "gets all cards that are overdue", %{card: card} do
      card = Repo.preload card, :prev_rep
      rep_params = %{due_date: Timex.shift(Timex.today, days: -1)}

      with {:ok, rep}   <- SRS.update_rep(card.prev_rep, rep_params),
           queued_cards <- SRS.queued_cards() do
        assert Enum.any? queued_cards, fn card ->
          card.prev_rep == rep
        end
      end
    end

    test "does not get cards that aren't due", %{card: card} do
      card = Repo.preload card, :prev_rep
      rep_params = %{due_date: Timex.shift(Timex.today, days: 1)}

      with {:ok, rep}   <- SRS.update_rep(card.prev_rep, rep_params),
           queued_cards <- SRS.queued_cards() do
        refute Enum.any? queued_cards, fn card ->
          card.prev_rep == rep
        end
      end
    end
  end

  defp setup_card(_state) do
    phrase = fixture(:phrase)
    card = fixture(:card, phrase)
    {:ok, phrase: phrase, card: card}
  end
end
