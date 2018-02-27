defmodule Tasktracker.Repo.Migrations.AddUniqueReportees do
  use Ecto.Migration

  def change do
    create unique_index(:reportees, [:manager_id, :repotee_id], name: :unique_indexes_for_reportees)
  end
end
