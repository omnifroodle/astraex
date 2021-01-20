defmodule AstraRestTest do
  use ExUnit.Case
  doctest Astra.Rest
  require UUID
  
  
  test "create row" do
    uuid = UUID.uuid4()
    row = %{name: "test row"}
    {:ok, _} = Astra.Rest.create("thing", uuid, row)
    {:ok, _} = Astra.Rest.read("thing", uuid)
  end
  
  # test "get row" do
  #   uuid = UUID.uuid4()
  #   {:ok, _} = Astra.Rest.read("thing", uuid)
  # end
  
end
