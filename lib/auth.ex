defmodule Idealixir.Auth do
  def base64_id_and_secret do
    with {:ok, id_and_secret} <- id_and_secret(),
    do: {:ok, Base.encode64(id_and_secret)}
  end

  def client_id do
    env_var("IDEALISTA_CLIENT_ID")
  end

  defp id_and_secret do
    with {:ok, client_id} <- env_var("IDEALISTA_CLIENT_ID"),
    {:ok, client_secret} <- env_var("IDEALISTA_CLIENT_SECRET"),
    do: {:ok, URI.encode(client_id) <> ":" <> URI.encode(client_secret)}
  end

  defp env_var(var_name) do
    case System.get_env(var_name) do
      nil   -> {:error, "Required environment variable, #{var_name}, was not set"}
      value -> {:ok, value}
    end
  end
end
