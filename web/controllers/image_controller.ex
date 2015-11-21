defmodule Gyazo.ImageController do
  use Gyazo.Web, :controller
  alias Gyazo.Repo
  alias Gyazo.Image

  def index(conn, _params) do
    text conn, "/"
  end

  def show(conn, %{"hash" => hash}) do
    image = Repo.get_by!(Image, hash: hash)
    hash = image.hash
    path = "/tmp/gyazo/#{hash}.png"
    conn
    |> put_resp_header("content-type", "image/png")
    |> send_file(200, path)
  end

  def create(conn, %{"imagedata" => imagedata} = params) do
    path = Map.get(imagedata, :path)
    image_params = %{
      "gyazo_id" => Map.get(params, "id", ""),
      "path" => path
    }
    changeset = Image.changeset(%Image{}, image_params)
    case Repo.insert(changeset) do
      {:ok, image} ->
        file_name = "#{Map.get(image, :hash)}.png"
      {:error, changeset} ->
        file_name = Ecto.Changeset.get_field(changeset, :hash)
    end
    text conn, "#{Gyazo.Endpoint.url}/" <> file_name
  end
end
