defmodule Idealixir.SearchParamParser do
  @doc ~S"""
  Parses a string representation of the desired number of bedrooms into a Range.

  ## Examples

      iex> Idealixir.SearchParamParser.bedrooms(nil)
      {:ok, 1..100}
      iex> Idealixir.SearchParamParser.bedrooms("3+")
      {:ok, 3..100}
      iex> Idealixir.SearchParamParser.bedrooms("2-4")
      {:ok, 2..4}
      iex> Idealixir.SearchParamParser.bedrooms("5")
      {:ok, 5..5}
      iex> Idealixir.SearchParamParser.bedrooms("nonsense")
      {:error, "Failed to parse 'nonsense'"}
  """
  def bedrooms(bedrooms) do
    cond do
    nil == bedrooms                                  -> n_or_more(1)
    match = Regex.run(~r/\A(\d+)\+\z/, bedrooms)     -> n_or_more(Enum.at(match, 1))
    match = Regex.run(~r/\A(\d+)-(\d+)\z/, bedrooms) -> n_to_m(Enum.at(match, 1), Enum.at(match, 2))
    match = Regex.run(~r/\A(\d+)\z/, bedrooms)       -> exactly_n(Enum.at(match, 1))
    true                                             -> {:error, "Failed to parse '#{bedrooms}'"}
    end
  end

  defp n_or_more(n) do
    {:ok, range(n, 100)}
  end

  defp n_to_m(n, m) do
    {:ok, range(n, m)}
  end

  defp exactly_n(n) do
    {:ok, range(n, n)}
  end

  defp range(lower, upper) do
    to_i(lower)..to_i(upper)
  end

  defp to_i(arg) when is_binary(arg), do: String.to_integer(arg)
  defp to_i(arg), do: arg
end
