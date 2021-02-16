defmodule AstraGraphqlTest do
  use ExUnit.Case
  doctest Astra.Graphql
  
  describe "schema" do
    test "query" do
      query = """
      query GetTables {
        keyspace(name: "test") {
          name
          tables {
            name
            columns {
              name
              kind
              type {
                basic
                info {
                  name
                }
              }
            }
          }
        }
      }
      """
      assert {:ok, %{keyspace: _}} = Astra.Graphql.schema(query)
    end
  end
  
  describe "keyspace" do
    test "query" do
      query = """
      query oneThing {
        thing(value: { id: "test" }) {
          values {
            id
            name
          }
        }
      }
      """
      assert {:ok, %{thing: %{values: []}}} = Astra.Graphql.tables("test", query)
    end
  end
end