defmodule Game.Worker do
  use GenServer

  import Ecto.Query

  alias Game.Repo
  alias Game.Score.User
  alias Game.Score

  def init(_arg) do
    state = %{max_number: :rand.uniform(100), last_query_time: nil}
    update_points()
    :timer.send_interval(60000, :work)
    {:ok, state}
  end

  def handle_call(:winners, _from, state) do
    previous_query_time = state[:last_query_time]
    state = update_last_query_time(state, DateTime.utc_now())
    winners = Score.get_two_winners(state[:max_number])
    {:reply, %{winners: winners, timestamp: previous_query_time}, state}
  end

  def handle_info(:work, state) do
    state = update_state(state)
    update_points()
    {:noreply, state}
  end

  defp update_state(state) do
    Map.put(state, :max_number, :rand.uniform(100))
  end

  defp update_points do
    step = 10_000
    ranges = Enum.to_list(0..990_000//step)
    |> Enum.map(fn start_id -> %{start_id: start_id, end_id: start_id + step} end)

    Repo.transaction(fn ->
      Task.async_stream(ranges,
        fn %{start_id: start_id, end_id: end_id} ->
          from(u in User, where: u.id > ^start_id and u.id <= ^end_id,
          update: [set: [points: fragment("floor(random()*100)"), updated_at: fragment("NOW()")]])
        |> Repo.update_all([]) end, ordered: false, max_concurrency: 5)
      |> Enum.reduce(0, fn {_, m}, _ -> IO.inspect(m, label: "UpdateResponse") end)
      end)
  end

  defp update_last_query_time(state, time) do
    Map.put(state, :last_query_time, time)
  end

end
