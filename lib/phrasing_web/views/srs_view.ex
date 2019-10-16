defmodule PhrasingWeb.SRSView do
  use PhrasingWeb, :view

  @icons_for_score [
    "fad fa-empty-set",
    "fad fa-angle-double-left",
    "fad fa-angle-left",
    "fad fa-redo-alt",
    "fad fa-angle-right",
    "fad fa-angle-double-right",
  ]

  def icon_for_score(score) do
    Enum.at @icons_for_score, score
  end
end
