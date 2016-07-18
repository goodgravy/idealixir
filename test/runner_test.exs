defmodule IdealixirRunnerTest do
  use ExUnit.Case
  doctest Idealixir.Runner
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

  test "search returns 50 results when bedroom count not specified" do
    use_cassette "search_success" do
      properties = Idealixir.Runner.search(
        center: "40.42938099999995,-3.7097526269835726",
        country: "es",
        maxItems: 50,
        numPage: 1,
        distance: 452,
        propertyType: "homes",
        operation: "sale",
      )

      assert length(properties) == 50
    end
  end

  test "search returns 1 result when looking for 10 bedrooms" do
    use_cassette "search_four_plus_bedrooms", match_requests_on: [:query] do
      properties = Idealixir.Runner.search(
        center: "40.42938099999995,-3.7097526269835726",
        bedrooms: "10",
        country: "es",
        maxItems: "50",
        numPage: "1",
        distance: "452",
        propertyType: "homes",
        operation: "sale",
      )

      assert length(properties) == 1
    end
  end

  test "search returns 2 results when looking for 8 or more bedrooms" do
    use_cassette "search_four_plus_bedrooms", match_requests_on: [:query] do
      properties = Idealixir.Runner.search(
        center: "40.42938099999995,-3.7097526269835726",
        bedrooms: "8+",
        country: "es",
        maxItems: "50",
        numPage: "1",
        distance: "452",
        propertyType: "homes",
        operation: "sale",
      )

      assert length(properties) == 2
    end
  end
end
