defmodule IdealixirAuthTest do
  use ExUnit.Case
  doctest Idealixir.Auth

  setup do
    System.put_env("IDEALISTA_CLIENT_ID", "client id")
    System.put_env("IDEALISTA_CLIENT_SECRET", "client secret")

    on_exit fn ->
      System.delete_env("IDEALISTA_CLIENT_ID")
      System.delete_env("IDEALISTA_CLIENT_SECRET")
    end

    :ok
  end

  test "with no client ID" do
    System.delete_env("IDEALISTA_CLIENT_ID")
    assert {:error, _} = Idealixir.Auth.base64_id_and_secret
  end

  test "with no client secret" do
    System.delete_env("IDEALISTA_CLIENT_SECRET")
    assert {:error, _} = Idealixir.Auth.base64_id_and_secret
  end

  test "with necessary environment variables" do
    assert {:ok, "Y2xpZW50JTIwaWQ6Y2xpZW50JTIwc2VjcmV0"} = Idealixir.Auth.base64_id_and_secret
  end

  test "getting client ID" do
    assert {:ok, "client id"} = Idealixir.Auth.client_id
  end
end
