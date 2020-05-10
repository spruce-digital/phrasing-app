defmodule Phrasing.AccountTest do
  use Phrasing.DataCase

  alias Phrasing.Account

  describe "jwts" do
    alias Phrasing.Account.JWT

    @valid_attrs %{token: "some token"}
    @update_attrs %{token: "some updated token"}
    @invalid_attrs %{token: nil}

    def jwt_fixture(attrs \\ %{}) do
      {:ok, jwt} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_jwt()

      jwt
    end

    test "list_jwts/0 returns all jwts" do
      jwt = jwt_fixture()
      assert Account.list_jwts() == [jwt]
    end

    test "get_jwt!/1 returns the jwt with given id" do
      jwt = jwt_fixture()
      assert Account.get_jwt!(jwt.id) == jwt
    end

    test "create_jwt/1 with valid data creates a jwt" do
      assert {:ok, %JWT{} = jwt} = Account.create_jwt(@valid_attrs)
      assert jwt.token == "some token"
    end

    test "create_jwt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_jwt(@invalid_attrs)
    end

    test "update_jwt/2 with valid data updates the jwt" do
      jwt = jwt_fixture()
      assert {:ok, %JWT{} = jwt} = Account.update_jwt(jwt, @update_attrs)
      assert jwt.token == "some updated token"
    end

    test "update_jwt/2 with invalid data returns error changeset" do
      jwt = jwt_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_jwt(jwt, @invalid_attrs)
      assert jwt == Account.get_jwt!(jwt.id)
    end

    test "delete_jwt/1 deletes the jwt" do
      jwt = jwt_fixture()
      assert {:ok, %JWT{}} = Account.delete_jwt(jwt)
      assert_raise Ecto.NoResultsError, fn -> Account.get_jwt!(jwt.id) end
    end

    test "change_jwt/1 returns a jwt changeset" do
      jwt = jwt_fixture()
      assert %Ecto.Changeset{} = Account.change_jwt(jwt)
    end
  end
end
