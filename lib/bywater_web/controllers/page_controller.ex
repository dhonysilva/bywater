defmodule BywaterWeb.PageController do
  use BywaterWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
