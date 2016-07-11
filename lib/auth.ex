defmodule Idealixir do
  defmodule Auth do
    def base64_id_and_secret do
      case id_and_secret do
        {:ok, id_and_secret} -> {:ok, Base.encode64(id_and_secret)}
        {_, message}         -> {:error, message}
      end
    end

    defp id_and_secret do
      case [encoded_client_id, encoded_client_secret] do
        [{:ok, encoded_client_id}, {:ok, encoded_client_secret}] -> {:ok, [encoded_client_id, encoded_client_secret] |> Enum.join(":")}
        [{_, id_error}, {_, secret_error}]                       -> {:error, [id_error, secret_error] |> Enum.join(". ")}
      end
    end

    defp encoded_client_id do
      case client_id do
        {:ok, client_id} -> {:ok, URI.encode client_id}
        {_, error}  -> {:error, error}
      end
    end

    defp encoded_client_secret do
      case client_secret do
        {:ok, client_secret} -> {:ok, URI.encode client_secret}
        {_, error}  -> {:error, error}
      end
    end

    defp client_id do
      case System.get_env("IDEALISTA_CLIENT_ID") do
        nil       -> {:error, "Required environment variable, IDEALISTA_CLIENT_ID, was not set"}
        client_id -> {:ok, client_id}
      end
    end

    defp client_secret do
      case System.get_env("IDEALISTA_CLIENT_SECRET") do
        nil           -> {:error, "Required environment variable, IDEALISTA_CLIENT_SECRET, was not set"}
        client_secret -> {:ok, client_secret}
      end
    end
  end
end

