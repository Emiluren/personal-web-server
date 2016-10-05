defmodule ChattApp.MusicController do
  use ChattApp.Web, :controller

  plug :put_layout, "MusicLayout.html"

  def index(conn, _params) do
    render conn, "index.html"
  end
end
