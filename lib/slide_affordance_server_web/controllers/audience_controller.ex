defmodule SlideAffordanceServerWeb.AudienceController do
  use SlideAffordanceServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
