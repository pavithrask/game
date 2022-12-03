defmodule Game.ScoreTest do
  use Game.DataCase

  alias Game.Score

  describe "users" do
    alias Game.Score.User

    import Game.ScoreFixtures

    @invalid_attrs %{points: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Score.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Score.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{points: 42}

      assert {:ok, %User{} = user} = Score.create_user(valid_attrs)
      assert user.points == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Score.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{points: 43}

      assert {:ok, %User{} = user} = Score.update_user(user, update_attrs)
      assert user.points == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Score.update_user(user, @invalid_attrs)
      assert user == Score.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Score.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Score.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Score.change_user(user)
    end
  end
end
