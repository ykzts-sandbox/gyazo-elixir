defmodule Gyazo.Router do
  use Gyazo.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Gyazo do
    pipe_through :api
  end
end
