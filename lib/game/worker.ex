defmodule Game.Worker do
  use GenServer

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
    now = DateTime.utc_now()
    last_query_time = nil
    state = %{max_number: :rand.uniform(100), last_query_time: last_query_time, timestamp: now}
    IO.inspect state, label: "Gen server is done working!"
    schedule_work()
    {:noreply, state}
  end
  defp schedule_work do
    # In 1 minute
    Process.send_after(self(), :work, 10 * 1000)
  end


end
