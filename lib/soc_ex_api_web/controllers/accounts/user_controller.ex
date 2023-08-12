defmodule SocExApiWeb.UserController do
  use SocExApiWeb, :controller

  alias SocExApi.Accounts
  alias SocExApi.Accounts.User

  action_fallback SocExApiWeb.FallbackController

  @paging_opts ~w(page page_size search order_by order_dir)

  def paginate(conn, params) do
    flop_opts = Map.take(params, @paging_opts)
    # param `order_by` is a string, so we need to convert it to a list split by comma (,)
    # evict key "order_by" not found in: %{"page" => "1", "page_size" => "5"} (KeyError)

    IO.inspect(flop_opts)

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
