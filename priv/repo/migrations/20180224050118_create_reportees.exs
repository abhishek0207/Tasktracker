defmodule Tasktracker.Repo.Migrations.CreateReportees do
  use Ecto.Migration

  def change do
    create table(:reportees) do
      add :manager_id, references(:users, on_delete: :nothing)
      add :repotee_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:reportees, [:manager_id])
    create index(:reportees, [:repotee_id])
  end
end
