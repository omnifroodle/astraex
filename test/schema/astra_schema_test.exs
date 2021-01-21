defmodule AstraSchemaTest do
  use ExUnit.Case
  doctest Astra.Schema

  # test "get keyspaces" do
  #   {:ok, data} = Astra.Schema.keyspaces()
  #   assert Enum.any?(data, fn x -> %{"name" => "system_schema"} = x end)
  # end
  
end