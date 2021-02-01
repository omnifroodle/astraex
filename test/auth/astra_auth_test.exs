defmodule AstraAuthTest do
  use ExUnit.Case
  doctest Astra.Auth
  @config Application.get_all_env(:astra)
  
  describe "login" do
    test "failure" do
      assert {:rejected, "unauthorized"} = Astra.Auth.authorize_user(@config[:username], @config[:password] <> "-")
    end
    
    test "success" do
      assert {:ok, %{authToken: _}} = Astra.Auth.authorize_user(@config[:username], @config[:password])
    end
  end
end