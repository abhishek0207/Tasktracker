defmodule Tasktracker.Repo.Migrations.AddUniqueUserInManager do
  use Ecto.Migration

  def change do
    create unique_index(:reportees, :repotee_id, name: :unique_index_for_repotee_id)
  end
end
