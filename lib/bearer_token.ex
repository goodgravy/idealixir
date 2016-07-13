defmodule Idealixir.BearerToken do
  @derive [Poison.Encoder]
  defstruct access_token: ""
end
