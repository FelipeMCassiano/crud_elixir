defmodule CrudLiveWeb.ApiController do
  use CrudLiveWeb, :controller

  alias CrudLive.Todo
  alias CrudLive.Repo

  def get_todo(conn, %{"id" => id}) do
    data = Repo.get(Todo, id)

    cond do
      data == nil -> conn |> put_status(404) |> json("Not found")
      data -> conn |> put_status(200) |> json(data)
    end
  end

  def get_all_todos(conn, _params) do
    data = Repo.all(Todo)
    conn |> put_status(200) |> json(data)
  end

  def create_todo(
        conn,
        %{"title" => title, "description" => description, "completed" => completed}
      ) do
    case Repo.insert(%Todo{title: title, description: description, completed: completed}) do
      {:ok, data} ->
        conn |> put_status(201) |> json(data)

      {:error, e} ->
        conn |> put_status(500) |> json(e)
    end
  end

  def delete_todo(conn, %{"id" => id}) do
    data = Repo.get(Todo, id)

    case delete_when_data_exists(data) do
      {:ok, res} -> conn |> put_status(200) |> json(res)
      {:error, e} -> conn |> put_status(500) |> json(e)
    end
  end

  defp delete_when_data_exists(data) when data != nil do
    Repo.delete(data)
  end

  def update_todo(conn, %{
        "id" => id,
        "title" => title,
        "description" => description,
        "completed" => completed
      }) do
    data = Repo.get(Todo, id)

    case update_when_data_exists(data, title, description, completed) do
      {:ok, res} -> conn |> put_status(200) |> json(res)
      {:error, e} -> conn |> put_status(500) |> json(e)
    end
  end

  defp update_when_data_exists(data, title, description, completed) when data != nil do
    changes =
      Ecto.Changeset.change(data, title: title, description: description, completed: completed)

    Repo.update(changes)
  end
end
