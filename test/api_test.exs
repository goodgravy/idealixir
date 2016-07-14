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

  test "search returns results" do
    use_cassette "search_success" do
      assert {:ok, response} = Idealixir.Api.search(%Idealixir.BearerToken{})
      assert response.status_code == 200
    end
  end

  test "authenticate returns a BearerToken" do
    use_cassette "get_token_success" do
      assert {:ok, token} = Idealixir.Api.authenticate
      assert token.access_token =~ ~r/eyJh.+miQo/
    end
  end

  test "authenticate returns an error if credentials are incorrect" do
    use_cassette "get_token_bad_credentials" do
      assert {:error, message} = Idealixir.Api.authenticate
      assert message["error"] == "unauthorized"
    end
  end
end
