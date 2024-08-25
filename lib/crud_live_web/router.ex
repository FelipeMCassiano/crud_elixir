defmodule CrudLiveWeb.Router do
  use CrudLiveWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CrudLiveWeb do
    pipe_through :api

    get "/todo/:id", ApiController, :get_todo
    post "/todo/create_todo", ApiController, :create_todo
    get "/todos", ApiController, :get_all_todos
    delete "/todo/delete/:id", ApiController, :delete_todo
    put "/todo/update/:id", ApiController, :update_todo
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:crud_live, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
