defmodule Tasktracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :body, :text
      add :status, :boolean, default: false, null: false
      add :createdBy_id, references(:users, on_delete: :delete_all), null: false
      add :assignedTo_id, references(:users, on_delete: :delete_all), null: false
      add :time_taken, :integer

      timestamps()
    end

    create index(:tasks, [:createdBy_id])
    create index(:tasks, [:assignedTo_id])
    
  end
end
