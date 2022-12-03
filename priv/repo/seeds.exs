# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Game.Repo.insert!(%Game.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Game.Repo
alias Game.Score.User

IO.puts('Runnig seeds.........')
users = List.duplicate(%{
  points: {:placeholder, :points},
  inserted_at: {:placeholder, :now},
  updated_at: {:placeholder, :now}}, 1_000)
IO.inspect length(users), label: "The users size is"

now =
  NaiveDateTime.utc_now()
  |> NaiveDateTime.truncate(:second)
placeholders = %{points: 0, now: now}

Repo.insert_all(
  User,
  users,
  placeholders: placeholders
)
