defmodule Idealixir.Api do
  use HTTPoison.Base

  @default_base_uri "https://api.idealista.com"

  def bearer_token do
    with {:ok, auth} <- Idealixir.Auth.base64_id_and_secret,
      {:ok, response} <- request("/oauth/token", "grant_type=client_credentials", auth),
    do: Poison.decode(response.body, as: %Idealixir.BearerToken{})
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

  defp request(path, body, auth) do
    post(path, body, [
      {"Authorization", "Basic " <> auth},
      {"Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"}
    ])
  end
end
