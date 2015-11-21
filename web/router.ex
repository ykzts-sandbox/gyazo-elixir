defmodule Gyazo.Router do
  use Gyazo.Web, :router

  pipeline :api do
  end

  scope "/", Gyazo do
    pipe_through :api

    get "/", ImageController, :index
    get "/:hash", ImageController, :show
    post "/upload", ImageController, :create
    options "/upload", ImageController, :options
  end
end
