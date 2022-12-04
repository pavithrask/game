defmodule Game.Worker do
  use GenServer

  import Ecto.Query

  alias Game.Repo
  alias Game.Score.User
  alias Game.Score

  def init(state) do
    state = %{max_number: :rand.uniform(100), last_query_time: nil}
    update_points()
    schedule_work()
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

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    # In 1 minute
    Process.send_after(self(), :work, 30 * 1000)


    # now = DateTime.utc_now()
    # IO.inspect now, label: "NOW"
    # # Every hour
    # next =
    #   now
    #   |> DateTime.add(-now.minute, :second)
    #   IO.inspect(label: "after -now.minute")
    #   |> DateTime.add(-now.second, :second)
    #   IO.inspect(label: "after -now.second")
    #   |> DateTime.add(-elem(now.microsecond, 0), :microsecond)
    #   IO.inspect(label: "after -now.microsecond")
    #   |> DateTime.add(10, :second)
    #   IO.inspect(label: "after second")
    # milliseconds_till_next = DateTime.diff(next, now, :millisecond)

    # IO.inspect next, label: "next"
    # IO.inspect milliseconds_till_next, label: "milliseconds_till_next"
    # Process.send_after(self(), :work, milliseconds_till_next)
  end

  def update_state(state) do
    Map.put(state, :max_number, :rand.uniform(100))
  end

  def update_points do
    update(User, set: [points: fragment("floor(random()*100)")])
    |> Repo.update_all([])
  end

  def update_last_query_time(state, time) do
    Map.put(state, :last_query_time, time)
  end

end
