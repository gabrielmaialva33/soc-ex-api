defmodule SocExApiWeb.UserController do
  use SocExApiWeb, :controller
  use Goal

  alias SocExApi.Accounts
  alias SocExApi.Accounts.User

  action_fallback SocExApiWeb.FallbackController

  def index(conn, params) do
    flop_opts = params |> SocExApi.Helpers.parse_pagination_params()

    with {:ok, flop} <- Flop.validate(flop_opts),
         {:ok, {users, meta}} <- Accounts.list_users(flop) do
      render(conn, :paginate, users: users, meta: meta)
    end
  end

  def create(conn, user_params) do
    # with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
    #   conn
    #   |> put_status(:created)
    #   |> put_resp_header("location", ~p"/api/users/#{user}")
    #   |> render(:show, user: user)
    # end
    with {:ok, attrs} <- validate(:create, user_params) do
      with {:ok, %User{} = user} <- Accounts.create_user(attrs) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/users/#{user}")
        |> render(:show, user: user)
      end
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

  defparams :create do
    required(:first_name, :string, min_length?: 1, max_length?: 40)
    required(:last_name, :string, min_length?: 1, max_length?: 40)
    required(:username, :string, min_length?: 1, max_length?: 40)
    required(:email, :string, format?: ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    required(:password, :string, format?: ~r/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$/)
    required(:password_confirmation, :string, equal?: :password)
  end
end
