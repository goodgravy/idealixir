defmodule Idealixir do
  defmodule Auth do
    def base64_id_and_secret do
      case id_and_secret do
        {:ok, id_and_secret} -> {:ok, Base.encode64(id_and_secret)}
        {_, message}         -> {:error, message}
      end
    end

    defp id_and_secret do
      with {:ok, client_id} <- encoded_env_var("IDEALISTA_CLIENT_ID"),
      {:ok, client_secret} <- encoded_env_var("IDEALISTA_CLIENT_SECRET"),
      do: {:ok, client_id <> ":" <> client_secret}
    end

    defp encoded_env_var(var_name) do
      case System.get_env(var_name) do
        nil   -> {:error, "Required environment variable, #{var_name}, was not set"}
        value -> {:ok, URI.encode value}
      end
    end
  end
end
