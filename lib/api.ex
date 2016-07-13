defmodule Idealixir.Api do
  use HTTPoison.Base

  @default_base_uri "https://api.idealista.com"

  def bearer_token do
    response = with {:ok, auth} <- Idealixir.Auth.base64_id_and_secret,
      {:ok, response} <- post("/oauth/token", "grant_type=client_credentials", [
        {"Authorization", "Basic " <> auth},
        {"Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"}
      ]),
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
end
