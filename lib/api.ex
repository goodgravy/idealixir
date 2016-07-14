defmodule Idealixir.Api do
  use HTTPoison.Base

  @default_base_uri "https://api.idealista.com"

  def search(token, params \\ []) do
    request("/3.5/es/search", "", "Bearer " <> token.access_token, params)
  end

  def authenticate do
    with {:ok, auth} <- Idealixir.Auth.base64_id_and_secret,
      {:ok, response} <- request("/oauth/token", "grant_type=client_credentials", "Basic " <> auth),
    do: parse_response(response)
  end

  def process_url(url) do
    base_uri <> url
  end

  defp base_uri do
    case System.get_env("IDEALISTA_BASE_URI") do
      nil   -> @default_base_uri
      value -> value
    end
  end

  defp request(path, body, auth, params \\ []) do
    post(path, body, [
      {"Authorization", auth},
      {"Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"}
    ], params: params)
  end

  defp parse_response(response) do
    case response.status_code do
      200 -> Poison.decode(response.body, as: %Idealixir.BearerToken{})
      _   -> {:error, Poison.Parser.parse!(response.body)}
    end
  end
end
