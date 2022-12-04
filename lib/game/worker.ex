defmodule Game.Worker do
  use GenServer

  import Ecto.Query

  alias Game.Repo
  alias Game.Score.User
  alias Game.Score

  def init(state) do
    # Schedule work to be performed on start
    state = %{max_number: :rand.uniform(100), last_query_time: nil}
    schedule_work()
    IO.inspect state, label: "state"
    {:ok, state}
  end

  def handle_call(:winners, _from, state) do
    IO.inspect state, label: "state"
    last_query_time = state[:last_query_time]
    state = Map.put(state, :last_query_time, DateTime.utc_now())
    IO.inspect state, label: "state"

    winners = Score.get_two_winners(state[:max_number])
    IO.inspect winners, label: "winners"

    {:reply, %{winners: winners, timestamp: last_query_time}, state}
  end

  def handle_info(:work, state) do
    # Do the desired work here
    IO.inspect DateTime.utc_now(), label: "WORKER START"

    # last_query_time = nil
    # state = %{max_number: :rand.uniform(100), last_query_time: last_query_time}
    state = Map.put(state, :max_number, :rand.uniform(100))
    update_points()

    IO.inspect state, label: "STATE"
    IO.inspect DateTime.utc_now(), label: "WORKER STOP"

    # Reschedule once more
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

  def update_points do
    update(User, set: [points: fragment("floor(random()*100)")])
    |> Repo.update_all([])
  end

end
