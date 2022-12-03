defmodule Game.ScoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Game.Score` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        points: 42
      })
      |> Game.Score.create_user()

    user
  end
end
