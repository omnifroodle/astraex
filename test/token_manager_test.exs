defmodule Loom.Astra.TokenManagerTest do
  use ExUnit.Case, async: true

  test "get token" do
    {:ok, _} = Astra.TokenManager.get_token()
  end
end