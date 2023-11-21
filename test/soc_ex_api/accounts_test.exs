defmodule SocExApi.AccountsTest do
  use SocExApi.DataCase

  alias SocExApi.Accounts

  describe "users" do
    alias SocExApi.Accounts.User
    alias SocExApi.UserFactory

    import SocExApi.AccountsFixtures

    @invalid_attrs %{
      username: nil,
      first_name: nil,
      last_name: nil,
      email: nil,
      password_hash: nil,
      is_online: nil,
      is_deleted: nil
    }

    test "list_users/0 returns all users" do
      users = UserFactory.create_many(3, %{is_deleted: false})

      assert {:ok, {data, %Flop.Meta{}}} = Accounts.list_users(%Flop{})
      assert Enum.sort(users) == Enum.sort(data)
    end

    test "get_user!/1 returns the user with given id" do
      user = UserFactory.create(%{is_deleted: false})
      fetched_user = Accounts.get_user!(user.id)
      assert user == fetched_user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = UserFactory.make(%{is_deleted: false})

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.username == valid_attrs.username
      assert user.first_name == valid_attrs.first_name
      assert user.last_name == valid_attrs.last_name
      assert user.email == valid_attrs.email
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = UserFactory.create(%{is_deleted: false})

      update_attrs = UserFactory.make(%{is_deleted: false})

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.username == update_attrs.username
      assert user.first_name == update_attrs.first_name
      assert user.last_name == update_attrs.last_name
      assert user.email == update_attrs.email
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = UserFactory.create(%{is_deleted: false})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = UserFactory.create(%{is_deleted: false})
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = UserFactory.create(%{is_deleted: false})
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "roles" do
    alias SocExApi.Accounts.Role
    alias SocExApi.RoleFactory

    import SocExApi.AccountsFixtures

    @invalid_attrs %{name: nil}

    test "list_roles/0 returns all roles" do
      roles = RoleFactory.create_many(3)

      assert {:ok, {data, %Flop.Meta{}}} = Accounts.list_roles(%Flop{})

      Enum.each(roles, fn role ->
        assert Enum.member?(data, role)
      end)
    end

    test "get_role!/1 returns the role with given id" do
      role = RoleFactory.create()
      assert Accounts.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      valid_attrs = RoleFactory.make()

      assert {:ok, %Role{} = role} = Accounts.create_role(valid_attrs)
      assert role.name == valid_attrs.name
      assert role.slug == valid_attrs.slug
      assert role.slug == String.downcase(valid_attrs.slug)
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = RoleFactory.create()
      update_attrs = RoleFactory.make()

      assert {:ok, %Role{} = role} = Accounts.update_role(role, update_attrs)
      assert role.name == update_attrs.name
      assert role.slug == String.downcase(update_attrs.name)
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = RoleFactory.create()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_role(role, @invalid_attrs)
      assert role == Accounts.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = RoleFactory.create()
      assert {:ok, %Role{}} = Accounts.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = RoleFactory.create()
      assert %Ecto.Changeset{} = Accounts.change_role(role)
    end
  end
end
