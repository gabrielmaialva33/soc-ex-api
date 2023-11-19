defmodule SocExApiWeb.UserControllerTest do
  use SocExApiWeb.ConnCase

  import SocExApi.AccountsFixtures

  alias SocExApi.Accounts.User

  @create_attrs %{
    username: "some username",
    first_name: "some first_name",
    last_name: "some last_name",
    email: "some email",
    password_hash: "some password_hash",
    is_online: true,
    is_deleted: true
  }
  @update_attrs %{
    username: "some updated username",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    email: "some updated email",
    password_hash: "some updated password_hash",
    is_online: false,
    is_deleted: false
  }
  @invalid_attrs %{
    username: nil,
    first_name: nil,
    last_name: nil,
    email: nil,
    password_hash: nil,
    is_online: nil,
    is_deleted: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "first_name" => "some first_name",
               "is_deleted" => true,
               "is_online" => true,
               "last_name" => "some last_name",
               "password_hash" => "some password_hash",
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "first_name" => "some updated first_name",
               "is_deleted" => false,
               "is_online" => false,
               "last_name" => "some updated last_name",
               "password_hash" => "some updated password_hash",
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
