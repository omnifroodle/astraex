defmodule AstraSchemaDocumentTest do
  use ExUnit.Case
  doctest Astra.Schema.Document

  test "get namespaces" do
    {:ok, data} = Astra.Schema.Document.get_namespaces()
    assert Enum.member?(data, %{name: "system_schema"})
  end
  
  # the following test should be correct based on the API spec, but
  # something is out of order between the spec and the implementation
  # test "get collections" do
  #   IO.inspect Astra.Schema.Document.get_collections("test")
  # end
  
  # test "create collection" do
  #   IO.inspect Astra.Schema.Document.create_collection("test", "new")
  # end
  
  # test "create namespace" do
  #   IO.inspect Astra.Schema.Document.create_namespace("blerg")
  # end
end