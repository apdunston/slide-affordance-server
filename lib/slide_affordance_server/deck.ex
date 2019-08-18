defmodule SlideAffordanceServer.Deck do
  @captions ["one", "two", "three", "four", "five"]

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link(_opts) do
    {:ok, pid} = Agent.start_link(fn -> {[], @captions} end)
    Process.register(pid, :deck)
    {:ok, pid}
  end

  def current do
    :deck
    |> Agent.get(fn {_prev, next} -> next end)
    |> hd()
  end

  def forward do
    {prev, next} = Agent.get(:deck, fn i -> i end)
    forward(prev, next)
  end

  defp forward(prev, next) when length(next) > 1 do
    [current|next] = next
    prev = [current|prev]
    Agent.update(:deck, fn _ -> {prev, next} end)
  end

  defp forward(_prev, _next), do: {:error, :end_of_deck}

  def back do
    {prev, next} = Agent.get(:deck, fn i -> i end)
    back(prev, next)
  end

  defp back(prev, next) when length(prev) > 0 do
    [last|prev] = prev
    next = [last|next]
    Agent.update(:deck, fn _ -> {prev, next} end)
  end

  defp back(_prev, _next), do: {:error, :beginning_of_deck}
end
