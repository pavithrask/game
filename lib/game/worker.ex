defmodule Game.Worker do
  use GenServer

  import Ecto.Query

  alias Game.Repo
  alias Game.Score.User

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end
  def init(state) do
    # Schedule work to be performed on start
    schedule_work()
    {:ok, state}
  end
  def handle_info(:work, state) do
    # Do the desired work here
    # ...
    # Reschedule once more
    IO.inspect state, label: "Gen server is doing some work........"
    now = DateTime.utc_now()
    last_query_time = nil
    state = %{max_number: :rand.uniform(100), last_query_time: last_query_time, timestamp: now}
    update_work()
    IO.inspect state, label: "Gen server is done working!"
    schedule_work()
    {:noreply, state}
  end
  defp schedule_work do
    # In 1 minute
    Process.send_after(self(), :work, 10 * 1000)
  end

  def update_work do
    user = %{points: {:placeholder, :points}, updated_at: {:placeholder, :now}}

    user_ids = Enum.to_list 1..100

    now =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    users =
      Enum.map(user_ids, &%{
        id: &1,
        points: {:placeholder, :points},
        updated_at: {:placeholder, :now}
      })

    placeholders = %{
      points: :rand.uniform(100),
      now: now
    }

    # Repo.all(from u in User, update: User, set: [points: fragment("floor(random()*100)")]
    # |> Repo.update_all([]))

    update(User, set: [points: fragment("floor(random()*100)")])
    |> Repo.update_all([])

    # Repo.update_all(
    #   User,
    #   users,
    #   placeholders: placeholders
    # )
  end

end
