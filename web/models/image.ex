defmodule Gyazo.Image do
  use Gyazo.Web, :model
  use Ecto.Model.Callbacks

  before_insert :save_uploaded_file

  schema "images" do
    field :gyazo_id, :string
    field :hash, :string
    field :path, :string, virtual: true

    timestamps
  end

  @required_fields ~w(path)
  @optional_fields ~w(gyazo_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:hash)
  end

  defp save_uploaded_file(changeset) do
    path = Ecto.Changeset.get_field(changeset, :path)
    hash = File.read!(path) |> generate_hash
    file_name = "#{hash}.png"
    File.copy!(path, "/tmp/gyazo/#{file_name}")
    change(changeset, %{hash: hash})
  end

  defp generate_hash(data) do
    :crypto.hash(:md5, data) |> Base.encode16(case: :lower)
  end
end
