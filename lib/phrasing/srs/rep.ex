defmodule Phrasing.SRS.Rep do
  use Ecto.Schema
  import Ecto.Changeset

  @default_ease 2.5
  @iteration_reset_boundary 3
  @repeat_boundary 3

  schema "reps" do
    field(:due_date, :date)
    field(:ease, :float, default: 2.5)
    field(:interval, :integer, default: 1)
    field(:iteration, :integer, default: 0)
    field(:overdue, :integer, default: 0)
    field(:score, :integer)

    belongs_to(:card, Phrasing.SRS.Card)
    belongs_to(:prev_rep, Phrasing.SRS.Rep)
    has_one(:next_rep, Phrasing.SRS.Rep, foreign_key: :prev_rep_id)

    timestamps()
  end

  @doc false
  def changeset(rep, attrs) do
    rep
    |> cast(attrs, [:score, :overdue, :ease, :interval, :iteration, :due_date, :card_id])
    |> add_default_due_date()
    |> validate_required([:overdue, :ease, :interval, :iteration, :due_date, :card_id])
  end

  def score_changeset(rep, prev_rep) do
    rep
    |> cast(%{prev_rep_id: prev_rep.id}, [:prev_rep_id])
    |> add_next_iteration(prev_rep)
    |> add_next_interval(prev_rep)
    |> add_next_ease(prev_rep)
    |> add_next_due_date(prev_rep)
    |> validate_required([:overdue, :ease, :interval, :iteration, :due_date, :card_id])
  end

  def add_default_due_date(changeset) do
    if is_nil(get_field(changeset, :due_date)) do
      put_change(changeset, :due_date, Timex.today())
    else
      changeset
    end
  end

  def add_next_iteration(changeset, rep) do
    score = get_field(changeset, :score)
    %{iteration: iteration} = rep

    if is_nil(rep.score) or score < @iteration_reset_boundary do
      put_change(changeset, :iteration, 0)
    else
      put_change(changeset, :iteration, iteration + 1)
    end
  end

  def add_next_interval(changeset, rep) do
    next_iteration = get_field(changeset, :iteration)

    next_interval =
      case next_iteration do
        0 -> 1
        1 -> 6
        _ -> round(rep.interval * rep.ease)
      end

    put_change(changeset, :interval, next_interval)
  end

  def add_next_ease(changeset, rep) do
    score = get_field(changeset, :score)

    # Do not change easing when an existing word is being restarted
    if rep.iteration >= 2 do
      next_ease = adjust_ease(rep.ease, score)
      put_change(changeset, :ease, Enum.max([1.3, next_ease]))
    else
      put_change(changeset, :ease, rep.ease)
    end
  end

  def add_next_due_date(changeset, rep) do
    score = get_field(changeset, :score)
    next_interval = get_field(changeset, :interval)

    cond do
      score > @repeat_boundary ->
        put_change(changeset, :due_date, Timex.shift(Timex.today(), days: next_interval))

      score == @repeat_boundary ->
        changeset
        |> put_change(:due_date, Timex.today())
        |> put_change(:interval, rep.interval)

      score < @repeat_boundary ->
        put_change(changeset, :due_date, Timex.today())
    end
  end

  def add_card_id(changeset, rep) do
    put_change(changeset, :card_id, rep.card_id)
  end

  def adjust_ease(ease, score) do
    ease + (0.1 - (5 - score) * (0.08 + (5 - score) * 0.02))
  end
end
