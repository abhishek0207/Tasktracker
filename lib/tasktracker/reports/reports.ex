defmodule Tasktracker.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo

  alias Tasktracker.Reports.Reportee

  @doc """
  Returns the list of reportees.

  ## Examples

      iex> list_reportees()
      [%Reportee{}, ...]

  """
  def list_reportees do
    Repo.all(Reportee)|>Repo.preload(:manager) |> Repo.preload(:reportee)
  end

  @doc """
  Gets a single reportee.

  Raises `Ecto.NoResultsError` if the Reportee does not exist.

  ## Examples

      iex> get_reportee!(123)
      %Reportee{}

      iex> get_reportee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reportee!(id), do: Repo.get!(Reportee, id)

  #created a non bang function -- Abhishek Ahuja
  def get_reportee(id), do: Repo.get(Reportee, id) |>Repo.preload(:manager) |> Repo.preload(:reportee)

  @doc """
  Creates a reportee.

  ## Examples

      iex> create_reportee(%{field: value})
      {:ok, %Reportee{}}

      iex> create_reportee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reportee(attrs \\ %{}) do
    IO.puts("attrs are")
    IO.inspect(attrs)
    %Reportee{}
    |> Reportee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reportee.

  ## Examples

      iex> update_reportee(reportee, %{field: new_value})
      {:ok, %Reportee{}}

      iex> update_reportee(reportee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reportee(%Reportee{} = reportee, attrs) do
    reportee
    |> Reportee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Reportee.

  ## Examples

      iex> delete_reportee(reportee)
      {:ok, %Reportee{}}

      iex> delete_reportee(reportee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reportee(%Reportee{} = reportee) do
    Repo.delete(reportee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reportee changes.

  ## Examples

      iex> change_reportee(reportee)
      %Ecto.Changeset{source: %Reportee{}}

  """
  def change_reportee(%Reportee{} = reportee) do
    Reportee.changeset(reportee, %{})
  end

  def get_user_manager(id) do
    Repo.one(from p in "reportees", where: p.repotee_id == ^id, select: p.manager_id)
  end

  def get_reportees(id) do
    Repo.all(from p in "reportees", where: p.manager_id == ^id, select: p.repotee_id)
  end

  def my_reportees(id) do
    Reportee |> Ecto.Query.where(manager_id: ^id)|>Repo.all|>Repo.preload(:manager) |> Repo.preload(:reportee)
  end
end
