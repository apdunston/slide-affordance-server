defmodule SlideAffordanceServerWeb.AudienceLive do
  use Phoenix.LiveView

  alias SlideAffordanceServer.Deck

  def render(assigns) do
    ~L"""
    <div aria-live="assertive">
      Caption: <%= @caption %>
    </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(100, self(), :tick)
    {:ok, assign(socket, caption: Deck.current, slide_number: Deck.slide_number)}
  end

  def handle_info(:tick, socket) do
    socket =
      socket
      |> update(:caption, fn _ -> Deck.current end)
      |> update(:slide_number, fn _ -> Deck.slide_number end)

    {:noreply, socket}
  end
end
