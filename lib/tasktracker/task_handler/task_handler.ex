defmodule Tasktracker.TaskHandler do
  @moduledoc """
  The TaskHandler context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo

  alias Tasktracker.TaskHandler.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task) |>Repo.preload(:creator) |> Repo.preload(:assigner)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)|>Repo.preload(:creator) |> Repo.preload(:assigner)

  #created a non bang function -- Abhishek Ahuja
  def get_task(id), do: Repo.get(Task, id)|>Repo.preload(:creator) |> Repo.preload(:assigner)

  def created_by(id) do
    Task |> Ecto.Query.where(assignedTo_id: ^id)|>Repo.all|>Repo.preload(:creator) |> Repo.preload(:assigner)
    # Repo.all(
     #from u in "tasks",
     #where: u.assignedTo_id == ^id,
     #select: [u.id, u.title, u.body, u.status, u.createdBy_id, u.assignedTo_id, u.inserted_at]
     #)
   end

   def getSelectData() do
    Repo.all(from(u in "users", select: {u.email, u.id}))
    end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end
  def count_tasks() do
    Repo.one(from p in "tasks", select: count(p.id))
  end
  def count_incomplete(ids) do
    Repo.one(from p in "tasks", where: [assignedTo_id: ^ids], where: p.status == false,  select: count(p.id))
  end
end
