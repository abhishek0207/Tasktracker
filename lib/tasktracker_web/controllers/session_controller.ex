#code inspired from proferssor's notes to establish session on the basis of email
defmodule TasktrackerWeb.SessionController do
  use TasktrackerWeb, :controller
  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User
  

  def create(conn, %{"email" => email}) do
    user = Accounts.get_user_by_email(email)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.name}")
      |> redirect(to: page_path(conn, :dashboard))
    else
      conn
      |> put_flash(:error, "Sorry, you are not registered, please register here")
      |> redirect(to: user_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    IO.puts("entered")
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
