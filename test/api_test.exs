defmodule IdealixirApiTest do
  use ExUnit.Case
  doctest Idealixir.Api

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup do
    System.put_env("IDEALISTA_CLIENT_ID", "client ID")
    System.put_env("IDEALISTA_CLIENT_SECRET", "client secret")

    on_exit fn ->
      System.delete_env("IDEALISTA_CLIENT_ID")
      System.delete_env("IDEALISTA_CLIENT_SECRET")
    end

    :ok
  end

  test "bearer_token" do
    use_cassette "get_token_success" do
      assert {:ok, response} = Idealixir.Api.bearer_token
      assert response.status_code == 200
      assert response.body =~ ~r/"access_token":"eyJh.+miQo"/
    end
  end
end
