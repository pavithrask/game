defmodule Game do
  def start_link(args) do
    GenServer.start_link(Game.Worker, args, name: :worker)
  end

  def get_winners() do
    GenServer.call(:worker, :winners)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
