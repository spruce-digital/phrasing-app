defmodule PhrasingWeb.FlashcardsView do
  use PhrasingWeb, :view

  @icons_for_score [
    "fal fa-exclamation-square",
    "fal fa-tired",
    "fal fa-times",
    "fal fa-repeat",
    "fal fa-check",
    "fal fa-laugh-beam",
  ]

  def render_score() do
    """
    <div class="score score-more">
      <i class="fal fa-bars"></i>
    </div>
    """
  end
  def render_score(score) when score < 6 do
    """
    <div class="score score-#{score}">
      <i class="#{Enum.at @icons_for_score, score}"></i>
    </div>
    """
  end
end
