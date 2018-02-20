defmodule TasktrackerWeb.Sessionplug do
  import Plug.Conn
  def init(options), do: options
  def call(conn, _opts) do
      user_id = get_session(conn, :user_id)
      user = Tasktracker.Accounts.get_user(user_id || -1)
      assign(conn, :current_user, user)
  end

end
