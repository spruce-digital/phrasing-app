defmodule PhrasingWeb.CardsView do
  use PhrasingWeb, :view

  alias Elixir.Timex.Format.DateTime.Formatters.Relative
  alias Phrasing.SRS.Card

  def relative_time date do
    Relative.format(date, "{relative}")
  end

  def relative_time! date do
    case relative_time date do
      {:ok, str} -> str
    end
  end

  def relative_day date do
    day = Timex.now()
          |> Timex.set([day: date.day, month: date.month, year: date.year])

    case Relative.format(day, "{relative}") do
      {:ok, "now"}  -> {:ok, "Today"}
      {:ok, string} -> {:ok, string}
      otherwise     -> otherwise
    end
  end

  def relative_day! date do
    case relative_day date do
      {:ok, str} -> str
    end
  end
end
