defmodule Phrasing.SRS.RepTest do
  use Phrasing.DataCase
  use ExUnit.Case
  use ExCheck
  import Ecto.Changeset

  alias Phrasing.SRS.{Rep}

  def for_each_score(callback) do
    # IO.inspect Enum.map(0..5, fn s -> callback.(s) end)
    score_failed = Enum.map(0..5, fn s -> callback.(s) end)
      |> Enum.member?(false)

    !score_failed
  end

  describe "score_changeset" do
    property :add_next_iteration do
      for_all iteration in int() do
        implies iteration >= 0 do
          for_each_score fn score ->
            rep = %Rep{iteration: iteration}
            changeset = %Rep{score: score}
                       |> Rep.changeset(%{})
                       |> Rep.add_next_iteration(rep)
            next_iteration = get_field(changeset, :iteration)

            if score < 3 do
              next_iteration == 0
            else
              next_iteration == iteration + 1
            end
          end
        end
      end
    end

    property :add_next_interval do
      for_all {iteration, interval} in {int(), int()} do
        implies iteration >= 0 && interval >= 1 do
          for_each_score fn score ->
            rep = %Rep{iteration: iteration, interval: interval}
            changeset = %Rep{score: score}
                        |> Rep.changeset(%{})
                        |> Rep.add_next_iteration(rep)
                        |> Rep.add_next_interval(rep)
            next_iteration = get_field(changeset, :iteration)
            next_interval = get_field(changeset, :interval)

            if next_iteration > 2 do
              next_interval == round(interval * 2.5)
            else
              Enum.member?([0, 1, 6], next_interval)
            end
          end
        end
      end
    end

    property :add_next_ease do
      for_all {iteration, interval, big_ease} in {int(), int(), int(25)} do
        implies iteration >= 0 && interval >= 1 do
          ease = Enum.max([big_ease / 10, 1.3])

          for_each_score fn score ->
            rep = %Rep{iteration: iteration, interval: interval, ease: ease}
            changeset = %Rep{score: score}
                        |> Rep.changeset(%{})
                        |> Rep.add_next_iteration(rep)
                        |> Rep.add_next_interval(rep)
                        |> Rep.add_next_ease(rep)
            next_ease = get_field(changeset, :ease)

            cond do
              iteration < 3 ->
                next_ease == ease

              next_ease > 1.3 ->
                next_ease == Rep.adjust_ease(ease, score)

              true ->
                score < 5
            end
          end
        end
      end
    end

    property :add_next_due_date do
      for_all {iteration, interval} in {int(), int()} do
        implies iteration >= 0 && interval >= 1 do
          for_each_score fn score ->
            rep = %Rep{iteration: iteration, interval: interval}
            changeset = %Rep{score: score}
                        |> Rep.changeset(%{})
                        |> Rep.add_next_iteration(rep)
                        |> Rep.add_next_interval(rep)
                        |> Rep.add_next_due_date(rep)
            next_interval = get_field(changeset, :interval)
            next_due_date = get_field(changeset, :due_date)

            case score do
              x when x > 3  -> Timex.diff(next_due_date, Timex.today, :days) > 0
              x when x == 3 -> next_interval == interval
              x when x < 3  -> Timex.today == next_due_date
            end
          end
        end
      end
    end
  end
end
