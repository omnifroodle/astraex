defmodule AstraSchemaRestTest do
  use ExUnit.Case
  doctest Astra.Schema.Rest

  describe "keyspace" do
    test "get" do
      {:ok, data} = Astra.Schema.Rest.get_keyspaces()
      assert Enum.member?(data, %{name: "system_schema"})
    end
    
    test "create" do
      # can't test this on an Astra backend, no keyspace creation
      assert {:rejected, "unauthorized"} = Astra.Schema.Rest.create_keyspace("test2")
    end
    
    test "delete" do
      assert {:rejected, "unauthorized"} = Astra.Schema.Rest.delete_keyspace("test")
    end
  end
  
  describe "tables" do
    test "get all" do
      {:ok, data} = Astra.Schema.Rest.get_tables("system_auth")
      assert Enum.any?(data, &(match?(&1, %{name: "roles"})) )
    end
    
    test "get one" do
      assert {:ok, _} = Astra.Schema.Rest.get_table("system_auth", "role_members")
    end
    
    test "create/drop" do
      table_name = "quatro"
      on_exit(fn ->
        Astra.Schema.Rest.drop_table("test", table_name)
      end)
      table = %{
                columnDefinitions: [
                  %{name: "id", static: false, typeDefinition: "text"},
                  %{name: "name", static: false, typeDefinition: "text"},
                  %{name: "description", static: false, typeDefinition: "text"}
                ],
                name: table_name,
                primaryKey: %{clusteringKey: ["name"], partitionKey: ["id"]},
                tableOptions: %{
                  clusteringExpression: [%{column: "name", order: "ASC"}],
                  defaultTimeToLive: 0
                }
              }
      
      assert {:ok, %{name: "quatro"}} = Astra.Schema.Rest.create_table("test", table)
    end
  end
  
end