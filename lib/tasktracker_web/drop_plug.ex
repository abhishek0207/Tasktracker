defmodule TasktrackerWeb.Dropdownplug do
  import Plug.Conn
  def init(options), do: options
  def call(conn, _opts) do
    user = Tasktracker.TaskHandler.getSelectData()
    assign(conn, :assigners, user)
  end

end
