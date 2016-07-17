defmodule Idealixir.Runner do
  def main(args) do
  end

  def search(search_params \\ []) do
    {:ok, token} = Idealixir.Api.authenticate

    {:ok, room_range} = params_to_range(search_params)
    api_param = room_range_to_api_param(room_range)
    search_params = Keyword.put(search_params, :bedrooms, api_param)

    {:ok, properties} = Idealixir.Api.search(token, search_params)
    properties |> Enum.filter(fn(property) ->
      Enum.member?(room_range, property.rooms)
    end)
  end

  defp params_to_range(params) do
    case Keyword.get(params, :bedrooms) do
      nil -> {:ok, 1..100}
      bedrooms -> Idealixir.SearchParamParser.bedrooms(bedrooms)
    end
  end

  defp room_range_to_api_param(bedrooms_range) do
    if Enum.min(bedrooms_range) > 4 do
      [4]
    else
      bedrooms_range |> Enum.filter(fn n -> n <= 4 end)
    end |> Enum.join(",")
  end
end
