defmodule TasktrackerWeb.TimeblockController do
  use TasktrackerWeb, :controller

  alias Tasktracker.TaskHandler
  alias Tasktracker.TaskHandler.Timeblock

  action_fallback TasktrackerWeb.FallbackController

  def index(conn, _params) do
    timeblocks = TaskHandler.list_timeblocks()
    render(conn, "index.json", timeblocks: timeblocks)
  end

  def create(conn, %{"timeblock" => timeblock_params}) do
    with {:ok, %Timeblock{} = timeblock} <- TaskHandler.create_timeblock(timeblock_params) do
      IO.inspect(timeblock.task_id)
      conn
      |> put_status(:created)
      |> put_resp_header("location", timeblock_path(conn, :show, timeblock))
      |>render( "show.json", timeblock: timeblock)
    end
  end

  def show(conn, %{"id" => id}) do
    timeblock = TaskHandler.get_timeblock!(id)
    render(conn, "show.json", timeblock: timeblock)
  end

  def update(conn, %{"id" => id, "timeblock" => timeblock_params}) do
    timeblock = TaskHandler.get_timeblock!(id)

    with {:ok, %Timeblock{} = timeblock} <- TaskHandler.update_timeblock(timeblock, timeblock_params) do
      render(conn, "show.json", timeblock: timeblock)
    end
  end

  def delete(conn, %{"id" => id}) do
    timeblock = TaskHandler.get_timeblock!(id)
    with {:ok, %Timeblock{}} <- TaskHandler.delete_timeblock(timeblock) do
      send_resp(conn, :no_content, "")
    end
  end
end
