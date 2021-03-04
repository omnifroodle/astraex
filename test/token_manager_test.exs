defmodule Loom.Astra.TokenManagerTest do
  use ExUnit.Case, async: true

  test "get remote token" do
    {:ok, _} = Astra.TokenManager.get_token()
  end
  
  test "get application token from local config" do
    {:ok, token} = Astra.TokenManager.get_current_token(nil, nil, "12345")
    assert token == "12345"
  end
end