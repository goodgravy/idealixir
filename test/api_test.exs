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

  test "bearer_token returns a token" do
    use_cassette "get_token_success" do
      assert {:ok, token} = Idealixir.Api.bearer_token
      assert token.access_token =~ ~r/eyJh.+miQo/
    end
  end

  test "bearer_token returns an error if credentials are incorrect" do
    use_cassette "get_token_bad_credentials" do
      assert {:error, message} = Idealixir.Api.bearer_token
      assert message["error"] == "unauthorized"
    end
  end
end
