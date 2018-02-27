defmodule Tasktracker.TaskHandlerTest do
  use Tasktracker.DataCase

  alias Tasktracker.TaskHandler

  describe "tasks" do
    alias Tasktracker.TaskHandler.Task

    @valid_attrs %{"": "some ", Status: true, body: "some body", title: "some title"}
    @update_attrs %{"": "some updated ", Status: false, body: "some updated body", title: "some updated title"}
    @invalid_attrs %{"": nil, Status: nil, body: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TaskHandler.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert TaskHandler.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert TaskHandler.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = TaskHandler.create_task(@valid_attrs)
      assert task. == "some "
      assert task.Status == true
      assert task.body == "some body"
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskHandler.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = TaskHandler.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task. == "some updated "
      assert task.Status == false
      assert task.body == "some updated body"
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskHandler.update_task(task, @invalid_attrs)
      assert task == TaskHandler.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = TaskHandler.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> TaskHandler.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = TaskHandler.change_task(task)
    end
  end

  describe "timeblocks" do
    alias Tasktracker.TaskHandler.Timeblock

    @valid_attrs %{end_time: ~N[2010-04-17 14:00:00.000000], start_time: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{end_time: ~N[2011-05-18 15:01:01.000000], start_time: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{end_time: nil, start_time: nil}

    def timeblock_fixture(attrs \\ %{}) do
      {:ok, timeblock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TaskHandler.create_timeblock()

      timeblock
    end

    test "list_timeblocks/0 returns all timeblocks" do
      timeblock = timeblock_fixture()
      assert TaskHandler.list_timeblocks() == [timeblock]
    end

    test "get_timeblock!/1 returns the timeblock with given id" do
      timeblock = timeblock_fixture()
      assert TaskHandler.get_timeblock!(timeblock.id) == timeblock
    end

    test "create_timeblock/1 with valid data creates a timeblock" do
      assert {:ok, %Timeblock{} = timeblock} = TaskHandler.create_timeblock(@valid_attrs)
      assert timeblock.end_time == ~N[2010-04-17 14:00:00.000000]
      assert timeblock.start_time == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_timeblock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskHandler.create_timeblock(@invalid_attrs)
    end

    test "update_timeblock/2 with valid data updates the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, timeblock} = TaskHandler.update_timeblock(timeblock, @update_attrs)
      assert %Timeblock{} = timeblock
      assert timeblock.end_time == ~N[2011-05-18 15:01:01.000000]
      assert timeblock.start_time == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_timeblock/2 with invalid data returns error changeset" do
      timeblock = timeblock_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskHandler.update_timeblock(timeblock, @invalid_attrs)
      assert timeblock == TaskHandler.get_timeblock!(timeblock.id)
    end

    test "delete_timeblock/1 deletes the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, %Timeblock{}} = TaskHandler.delete_timeblock(timeblock)
      assert_raise Ecto.NoResultsError, fn -> TaskHandler.get_timeblock!(timeblock.id) end
    end

    test "change_timeblock/1 returns a timeblock changeset" do
      timeblock = timeblock_fixture()
      assert %Ecto.Changeset{} = TaskHandler.change_timeblock(timeblock)
    end
  end
end
