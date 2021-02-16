defmodule Astra.Graphql do
  alias Astra.Graphql.Http
  @moduledoc """
  Provides functions to access the public methods of the GraphQL API for databases hosted on https://astra.datastax.com. 
  
  Astra's GraphQL API is implemented using the stargate project, https://stargate.io. 
  
  If required, raw access to the Astra REST Document API can be obtained through the `Astra.Graphql.Http` module.
  
  """
  
  
  @doc """
  Send queries to the graphql Schema endpoint
  
  ## Parameters
  
    - query: a valid graphql schema query
    - collection: name of the document collection
    - doc: the new document. 
    
  ## Examples
  
  ```
  > query = \""" 
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
          \"""
  > Astra.Graphql.schema(query)
  ```
  
  """
    
  @spec schema(String) :: {Atom, Map}
  def schema(query), do: Http.post("-schema", query) |> Http.parse_response
  
  @doc """
  Send queries to the graphql Schema endpoint
  
  ## Parameters
  
    - query: a valid graphql schema query
    - collection: name of the document collection
    - doc: the new document. 
    
  ## Examples
  
  ```
  > query = \"""
      query oneThing {
        thing(value: { id: "test" }) {
          values {
            id
            name
          }
        }
      }
      \"""
  > Astra.Graphql.tables("test", query)
  ```
  
  """
  @spec tables(String, String) :: {Atom, Map}
  def tables(keyspace, query), do: Http.post("/#{keyspace}", query) |> Http.parse_response
end