defmodule Game.Worker do
  use GenServer

  import Ecto.Query

  alias Game.Repo
  alias Game.Score.User
  alias Game.Score

  def init(state) do
    state = %{max_number: :rand.uniform(100), last_query_time: nil}
    update_points()
    :timer.send_interval(20_000, :work)
    IO.inspect state, label: "state"
    {:ok, state}
  end

  def handle_call(:winners, _from, state) do
    IO.inspect state, label: "current_state"

    previous_query_time = state[:last_query_time]
    state = update_last_query_time(state, DateTime.utc_now())

    IO.inspect state, label: "new_state"

    winners = Score.get_two_winners(state[:max_number])

    IO.inspect winners, label: "winners"

    {:reply, %{winners: winners, timestamp: previous_query_time}, state}
  end

  def handle_info(:work, state) do
    IO.inspect state, label: "current_state"
    IO.inspect DateTime.utc_now(), label: "work in progress"

    state = update_state(state)
    update_points()

    IO.inspect DateTime.utc_now(), label: "work done"
    IO.inspect state, label: "new_state"

    {:noreply, state}
  end

  defp update_state(state) do
    Map.put(state, :max_number, :rand.uniform(100))
  end

  defp update_id_range(%{start: start_id, end: end_id}) do
    from(u in User, where: u.id > ^start_id and u.id <= ^end_id, update: [set: [points: fragment("floor(random()*100)")]])
    |> Repo.update_all([])
  end

  def update_id_range(start_id, start_id) do
    IO.inspect start_id, label: "start_id"
  end

  def func(i) do
    IO.puts("Function running")
  end

  defp update_points do
    time1 = NaiveDateTime.utc_now

    step = 10_000
    ranges = Enum.to_list(0..990_000//step)
    |> Enum.map(fn start_id -> %{start_id: start_id, end_id: start_id + step} end)

    Repo.transaction(fn ->
      Task.async_stream(ranges,
        fn %{start_id: start_id, end_id: end_id} ->
          from(u in User, where: u.id > ^start_id and u.id <= ^end_id,
          update: [set: [points: fragment("floor(random()*100)"), updated_at: fragment("NOW()")]])
        |> Repo.update_all([]) end, ordered: false, max_concurrency: 5)
      |> Enum.reduce(0, fn {n, m}, _ -> IO.inspect(m, label: "UpdateResponse") end)
      end)


    time2 = NaiveDateTime.utc_now
    time_total = NaiveDateTime.diff(time2, time1, :microsecond)
    IO.inspect time_total, label: "time"
  end

  defp update_last_query_time(state, time) do
    Map.put(state, :last_query_time, time)
  end

end
