defmodule UploadsWeb.PageController do
  use UploadsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
