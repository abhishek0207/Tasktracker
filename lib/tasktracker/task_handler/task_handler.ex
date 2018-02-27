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
  def assigned_tasks(id) do
    query = from p in "reportees", where: p.manager_id == ^id, select: p.repotee_id
    Repo.all(from e in Task, join: s in subquery(query), on: s.repotee_id == e.assignedTo_id)|>Repo.preload(:creator) |> Repo.preload(:assigner)
  end

  alias Tasktracker.TaskHandler.Timeblock

  @doc """
  Returns the list of timeblocks.

  ## Examples

      iex> list_timeblocks()
      [%Timeblock{}, ...]

  """
  def list_timeblocks do
    Repo.all(Timeblock)
  end

  @doc """
  Gets a single timeblock.

  Raises `Ecto.NoResultsError` if the Timeblock does not exist.

  ## Examples

      iex> get_timeblock!(123)
      %Timeblock{}

      iex> get_timeblock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timeblock!(id), do: Repo.get!(Timeblock, id)

  @doc """
  Creates a timeblock.

  ## Examples

      iex> create_timeblock(%{field: value})
      {:ok, %Timeblock{}}

      iex> create_timeblock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timeblock(attrs \\ %{}) do
    %Timeblock{}
    |> Timeblock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a timeblock.

  ## Examples

      iex> update_timeblock(timeblock, %{field: new_value})
      {:ok, %Timeblock{}}

      iex> update_timeblock(timeblock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timeblock(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> Timeblock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Timeblock.

  ## Examples

      iex> delete_timeblock(timeblock)
      {:ok, %Timeblock{}}

      iex> delete_timeblock(timeblock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timeblock(%Timeblock{} = timeblock) do
    Repo.delete(timeblock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timeblock changes.

  ## Examples

      iex> change_timeblock(timeblock)
      %Ecto.Changeset{source: %Timeblock{}

  """
  def change_timeblock(%Timeblock{} = timeblock) do
    Timeblock.changeset(timeblock, %{})
  end
  def gettimeMap(user_id) do
   Repo.all(from p in Timeblock, where: is_nil(p.end_time), group_by: [:user_id, :task_id, :id, :end_time], select: %{"id" => p.id , "start_time" => max(p.start_time), "user_id" => p.user_id, "task_id" => p.task_id, "end_time" => p.end_time})
  end
  def eachTaskEndTime(taskmap) do
    Repo.all(from p in Timeblock, where: p.task_id == ^taskmap["task_id"], select: %{"id"=> p.id, "task_id" => p.task_id })
  end
  def getTaskTimeblocks(task_id) do
    Repo.all(from p in Timeblock, where: p.task_id == ^task_id, select: %{"id" => p.id, "start_time"=> p.start_time, "end_time" => p.end_time})
  end
end
