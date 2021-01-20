defmodule Loom.Astra.TokenManagerTest do
  use ExUnit.Case, async: true

  # setup do
  #   start_supervised!(Astra.TokenManager)
  #   %{}
  # end

  test "get token" do
    {:ok, _} = Astra.TokenManager.get_token()
  end
end