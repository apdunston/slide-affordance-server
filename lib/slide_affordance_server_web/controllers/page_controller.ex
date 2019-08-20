defmodule SlideAffordanceServerWeb.PageController do
  use SlideAffordanceServerWeb, :controller

  alias SlideAffordanceServer.Deck

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def audience(conn, _) do
    live_render(conn, SlideAffordanceServerWeb.AudienceLive, session: %{})
  end

  def forward(conn, _) do
    Deck.forward()
    json(conn, %{status: :ok})
  end

  def back(conn, _) do
    Deck.back()
    json(conn, %{status: :ok})
  end

  def reset(conn, _) do
    Deck.reset()
    json(conn, %{status: :ok})
  end
end
