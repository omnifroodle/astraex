defmodule Astra.Schema.Rest do
  alias Astra.Schema.Http
  @moduledoc """
  Functions for working with the REST (aka keyspace) schema APIs
  
  """
  
  
  @doc """
  retrieve a list of all keyspaces in the cluster
  
  """
  def get_keyspaces, do: Http.get("keyspaces") |> Http.parse_response
  
  @doc """
  create a new keyspace (NOTE: Not avialable on Astra)
  """
  def create_keyspace(name), do: Http.post("keyspaces", "{\"name\": \"#{name}\"}") |> Http.parse_response

  @doc """
  delete a keyspace (NOTE: Not avialable on Astra)
  """
  def delete_keyspace(name), do: Http.delete("keyspaces/#{name}") |> Http.parse_response
  
  @doc """
  get tables for a keyspace
  
  ## Examples
  
  > Astra.Schema.Rest.get_tables("system_auth")
  {:ok,
    [
      %{
        columnDefinitions: [
          %{name: "role", static: false, typeDefinition: "varchar"},
          %{name: "member", static: false, typeDefinition: "varchar"}
        ],
        keyspace: "system_auth",
        name: "role_members",
        primaryKey: %{
          clusteringKey: ["member"],
          partitionKey: ["role"]
        },
        tableOptions: %{
          clusteringExpression: [%{column: "member", order: "ASC"}],
          defaultTimeToLive: 0
        }
      },
      %{
        columnDefinitions: [
          %{name: "role", static: false, typeDefinition: "varchar"},
          %{name: "resource", static: false, typeDefinition: "varchar"},
          %{
            name: "grantables",
            static: false,
            typeDefinition: "set<varchar>"
          },
          %{
            name: "permissions",
            static: false,
            typeDefinition: "set<varchar>"
          },
          %{
            name: "restricted",
            static: false,
            typeDefinition: "set<varchar>"
          }
        ],
        keyspace: "system_auth",
        name: "role_permissions",
        primaryKey: %{
          clusteringKey: ["resource"],
          partitionKey: ["role"]
        },
        tableOptions: %{
          clusteringExpression: [%{column: "resource", order: "ASC"}],
          defaultTimeToLive: 0
        }
      },
      %{
        columnDefinitions: [
          %{name: "role", static: false, typeDefinition: "varchar"},
          %{
            name: "can_login",
            static: false,
            typeDefinition: "boolean"
          },
          %{
            name: "is_superuser",
            static: false,
            typeDefinition: "boolean"
          },
          %{
            name: "member_of",
            static: false,
            typeDefinition: "set<varchar>"
          },
          %{
            name: "salted_hash",
            static: false,
            typeDefinition: "varchar"
          }
        ],
        keyspace: "system_auth",
        name: "roles",
        primaryKey: %{clusteringKey: [], partitionKey: ["role"]},
        tableOptions: %{clusteringExpression: [], defaultTimeToLive: 0}
      }
    ]}
  """
  def get_tables(keyspace), do: Http.get("keyspaces/#{keyspace}/tables") |> Http.parse_response

  @doc """
  get a specific table in a keyspace
  
  ## Examples
  iex> Astra.Schema.Rest.get_table("system_auth", "role_members")
  {:ok,
    %{
      columnDefinitions: [
        %{name: "role", static: false, typeDefinition: "varchar"},
        %{name: "member", static: false, typeDefinition: "varchar"}
      ],
      keyspace: "system_auth",
      name: "role_members",
      primaryKey: %{clusteringKey: ["member"], partitionKey: ["role"]},
      tableOptions: %{
        clusteringExpression: [%{column: "member", order: "ASC"}],
        defaultTimeToLive: 0
      }
    }
  }
  """
  def get_table(keyspace, table), do: Http.get("keyspaces/#{keyspace}/tables/#{table}") |> Http.parse_response

  @doc """
  create a new table
  
  See https://stargate.io/docs/stargate/1.0/developers-guide/api_ref/openapi_rest_ref.html#Table for the table creation schema
  ## Examples
  ```
  > table = %{
                columnDefinitions: [
                  %{name: "id", typeDefinition: "text"},
                  %{name: "name", typeDefinition: "text"},
                  %{name: "description", typeDefinition: "text"}
                ],
                name: "demo",
                primaryKey: %{clusteringKey: ["name"], partitionKey: ["id"]}
              }
            
  > Astra.Schema.Rest.create_table("test", table)
  ```
  
  """
  def create_table(keyspace, table), do: Http.post("keyspaces/#{keyspace}/tables", Http.json!(table)) |> Http.parse_response

  @doc """
  drop a  table
  
  ## Examples
  ```       
  > Astra.Schema.Rest.drop_table("test", "table_name")
  ```
  
  """
  def drop_table(keyspace, table), do: Http.delete("keyspaces/#{keyspace}/tables/#{table}") |> Http.parse_response

end