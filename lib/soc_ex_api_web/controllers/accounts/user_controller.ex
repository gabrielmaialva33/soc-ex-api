defmodule SocExApiWeb.UserController do
  use SocExApiWeb, :controller

  alias SocExApi.Accounts
  alias SocExApi.Accounts.User

  action_fallback SocExApiWeb.FallbackController

  @paging_opts ~w(page page_size search order_by order_dir)

  def paginate(conn, params) do
    # ?order_by[]=first_name&order_by[]=last_name&order_directions[]=asc&order_directions[]=desc
    # params order_by: first_name,last_name,username separate by comma
    # %{order_by: [:first_name, :last_name], order_directions: [:asc, :desc]}
    # next line convert to map and remove all params except paging_opts keys
    # %{order_by: ["first_name", "last_name"], order_directions: ["asc", "desc"]}
    flop_opts =
      params
      |> Map.take(@paging_opts)
      |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
      # if not exist value in map if exist key split by comma and convert to atom list else put default value
      |> Map.put(
        :order_by,
        (params["order_by"] || ["first_name"])
        |> String.split(",")
        |> Enum.map(&String.to_atom/1)
      )
      |> IO.inspect(label: "flop_opts")

    # if not exist key in map, put default value
    #      |> Map.update!(:order_by, &String.split(&1, ","))
    #      |> Map.update!(:order_directions, &String.split(&1, ","))

    with {:ok, flop} <- Flop.validate(flop_opts),
         {:ok, {users, meta}} <- Accounts.paginate_users(flop) do
      render(conn, :paginate, users: users, meta: meta)
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
