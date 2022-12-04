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
users = List.duplicate(%{}, 1_000_000)
IO.inspect length(users), label: "The users size is"
list_of_user_chunks = Enum.chunk_every(users, 200000)
time1 = NaiveDateTime.utc_now

parent = self()
Repo.transaction(fn ->
  users
    |> Stream.chunk_every(10_000)
    |> Task.async_stream(fn batch ->
      {n, _} = Repo.insert_all(User, batch, caller: parent)
      n
    end, ordered: false, max_concurrency: 10)
    |> Enum.reduce(0, fn {:ok, n}, acc -> acc + n end)
  end)

time2 = NaiveDateTime.utc_now
time_total = NaiveDateTime.diff(time2, time1, :microsecond)
IO.inspect time_total, label: "time"
