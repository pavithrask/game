defmodule GameWeb.UserView do
  use GameWeb, :view
  alias GameWeb.UserView

  def render("index.json", %{winners: winners, timestamp: last_query_time}) do
    %{
      users: render_many(winners, UserView, "user.json"),
      timestamp: last_query_time
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      points: user.points
    }
  end
end
