defmodule UploadsWeb.UploadController do
  use UploadsWeb, :controller
  alias Uploads.Documents
  alias Uploads.Documents.Upload

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"upload" => %Plug.Upload{} = upload}) do
    case Documents.create_upload_from_plug_upload(upload) do
      {:ok, _upload} ->
        put_flash(conn, :info, "upload success")
        redirect(conn, to: Routes.upload_path(conn, :index))

      {:error, reason} ->
        put_flash(conn, :error, "upload failed: #{inspect(reason)}")
        render(conn, "new.html")
    end
  end

  def index(conn, _params) do
    uploads = Documents.list_uploads()
    render(conn, "index.html", uploads: uploads)
  end

  def show(conn, %{"id" => id}) do
    upload = Documents.get_upload!(id)
    local_path = Upload.local_path(upload.id, upload.filename)
    send_download(conn, {:file, local_path}, filename: upload.filename)
  end
end
