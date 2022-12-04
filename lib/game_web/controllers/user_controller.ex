defmodule GameWeb.UserController do
  use GameWeb, :controller

  alias Game.Score
  alias Game.Score.User

  action_fallback GameWeb.FallbackController

  def index(conn, _params) do
    users = Game.get_winners()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Score.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Score.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Score.get_user!(id)

    with {:ok, %User{} = user} <- Score.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Score.get_user!(id)

    with {:ok, %User{}} <- Score.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
