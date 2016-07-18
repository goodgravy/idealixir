defmodule Idealixir.Runner do
  def main(args) do
    {command, extras} = args |> parse_args
    process(command, extras)
  end

  def search(search_params \\ []) do
    {:ok, token} = Idealixir.Api.authenticate

    {:ok, room_range} = params_to_rooms_range(search_params)
    api_param = rooms_range_to_api_param(room_range)
    search_params = Keyword.put(search_params, :bedrooms, api_param)

    {:ok, properties} = Idealixir.Api.search(token, search_params)
    Enum.filter(properties, fn(property) ->
      Enum.member?(room_range, property.rooms)
    end)
  end

  defp process(command, extras) do
    case command do
      "search" -> search(extras)
      "echo"   -> echo(extras)
      _        -> IO.puts "Sorry, only 'search' is supported at the moment (got #{command})"
    end
  end

  defp echo(extras) do
    IO.puts inspect(extras)
  end

  defp parse_args(args) do
    {extras, [command], _} = OptionParser.parse(args)
    {command, extras}
  end

  defp params_to_rooms_range(params) do
    case Keyword.get(params, :bedrooms) do
      nil -> {:ok, 1..100}
      bedrooms -> Idealixir.SearchParamParser.bedrooms(bedrooms)
    end
  end

  defp rooms_range_to_api_param(bedrooms_range) do
    if Enum.min(bedrooms_range) > 4 do
      [4]
    else
      bedrooms_range |> Enum.filter(fn n -> n <= 4 end)
    end |> Enum.join(",")
  end
end
