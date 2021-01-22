defmodule Astra.Rest do
  alias Astra.Rest.Http
  @moduledoc """
  `Astra.Rest` provides functions to access the public methods of the REST interface for databases hosed on https://astra.datastax.com.
  
  Astra's REST interface is implemented using the stargate project, https://stargate.io. Swagger docs for this interface are available here https://docs.astra.datastax.com/reference#keyspaces-2.
  
  If required, raw access to the Astra REST api can be obtained through the `Astra.Rest.Http` module.
  """
  
  
  @doc """
  `get_row` retrieves one or more rows based on the `keyspace`, `table` and `primary_key`. Primary keys that span multiple fields
  should be delimeted with a `\\` ex. "123\\tuesday".
  
  ## Examples
  ```
  > Astra.Rest.get_row("test", "thing", "83b8d85d-bd33-4650-8b9d-b43354187114") 
  {:ok, [%{id: "83b8d85d-bd33-4650-8b9d-b43354187114", name: "test row"}]}
  ```
  
  """
  @spec get_row(String, String, String) :: {Atom, list(Map)}
  def get_row(keyspace, table, primary_key), do: Http.get("#{keyspace}/#{table}/#{primary_key}") |> Http.parse_response

  @doc """
  Add a row. All fields in the row are optional except for fields defined in the `PRIMARY KEY` of the table definition.
  
  ## Parameters
  
    - keyspace: the keyspace containing the target table
    - table: the table containing the entity we are retrieving
    - entity: a Map of the attributes of the row we are adding
    
    ex.
    ```
      %{
        id: "83b8d85d-bd33-4650-8b9d-b43354187114",
        name: "test row"
      }
    ```
  ## Examples
  
  ```
    > new_row = %{id: "83b8d85d-bd33-4650-8b9d-b43354187114", name: "test row"}
    > Astra.Rest.add_row("test", "thing", new_row)
    {:ok, %{id: "83b8d85d-bd33-4650-8b9d-b43354187114"}}
  ```
  
  """
  @spec add_row(String, String, Map) :: {Atom, Map}
  def add_row(keyspace, table, entity), do: Http.post("#{keyspace}/#{table}", Http.json!(entity)) |> Http.parse_response
  
  @doc """
  Update part of a row, only fields provided in the entity will be updated.

  ## Parameters
  
    - keyspace: the keyspace containing the target table
    - table: the table containing the entity we are retrieving
    - key: a primary key, if it contains multiple fields they should be seperated with `\\`
    - entity: a Map of the attributes of the row we are adding
    
    ex.
    ```
      %{
        id: "83b8d85d-bd33-4650-8b9d-b43354187114",
        name: "test row"
      }
    ```
  ## Examples
  
  ```
    > new_row = %{id: "83b8d85d-bd33-4650-8b9d-b43354187114", name: "test row"}
    > Astra.Rest.add_row("test", "thing", new_row)
    {:ok, %{id: "83b8d85d-bd33-4650-8b9d-b43354187114"}}
  ```
  
  """
  @spec update_partial_row(String, String, String, Map) :: {Atom, Map}
  def update_partial_row(keyspace, table, key, changes), do: Http.patch("#{keyspace}/#{table}/#{key}", Http.json!(changes)) |> Http.parse_response
  
  @doc """
  Similar to `Astra.Rest.add_row/3`, the key needs to be provided explicity.

  ## Parameters
  
    - keyspace: the keyspace containing the target table
    - table: the table containing the entity we are retrieving
    - key: a primary key, if it contains multiple fields they should be seperated with `\\`
    - entity: a Map of the attributes of the row we are adding
    
    ex.
    ```
      %{
        id: "83b8d85d-bd33-4650-8b9d-b43354187114",
        name: "test row"
      }
    ```
  ## Examples
  
  ```
    > new_row = %{name: "test row"}
    > Astra.Rest.replace_row("test", "thing", "83b8d85d-bd33-4650-8b9d-b43354187115", new_row)
    {:ok, %{name: "test row"}}
    > Astra.Rest.get_row("test", "thing", "83b8d85d-bd33-4650-8b9d-b43354187115")
    {:ok, [%{id: "83b8d85d-bd33-4650-8b9d-b43354187115", name: "test row"}]}
  ```
  
  """
  @spec replace_row(String, String, String, Map) :: {Atom, Map}
  def replace_row(keyspace, table, key, entity), do: Http.put("#{keyspace}/#{table}/#{key}", Http.json!(entity)) |>Http.parse_response

  
  @doc """
  Remove a row.
  
  ## Parameters
  
    - keyspace: the keyspace containing the target table
    - table: the table containing the entity we are retrieving
    - key: a primary key, if it contains multiple fields they should be seperated with `\\`

  ## Examples
  
  ```
    > new_row = %{id: "83b8d85d-bd33-4650-8b9d-b43354187114", name: "test row"}
    > Astra.Rest.delete_row("test", "thing", "83b8d85d-bd33-4650-8b9d-b43354187114")
    {:ok, []]}
  ```
  
  
  """
  # delete row
  @spec delete_row(String, String, String) :: {Atom, []}
  def delete_row(keyspace, table, key), do: Http.delete("#{keyspace}/#{table}/#{key}") |> Http.parse_response
  
  # search a table
  
  # CREATE CUSTOM INDEX things_name_idx ON thing (name) USING 'StorageAttachedIndex' WITH OPTIONS = {'normalize': 'true', 'case_sensitive': 'false'};
  @doc """
  Search for rows in a table. The following operators are available for the query: `$eq`, `$lt`, `$lte`, `$gt`, `$gte`, `$ne`, and `$exists`.
  
  Please note that some restrictions exist for searches:
  
  1. Search cannot be on a `PRIMARY KEY` field, unless a composite primary key is being used.
  2. Search fields will require some form of secondary index.  SAI is usually the best choice https://docs.astra.datastax.com/docs/using-storage-attached-indexing-sai
  
  Example of creating an SAI index on a table:
  ```
  CREATE TABLE thing (
    id text PRIMARY KEY,
    name text
  ) 
  
  CREATE CUSTOM INDEX things_name_idx 
    ON thing (name) USING 'StorageAttachedIndex' 
    WITH OPTIONS = {'normalize': 'true', 'case_sensitive': 'false'};
  ```
  ## Parameters
  
    - keyspace: the keyspace containing the target table
    - table: the table containing the entity we are retrieving
    - query: the search query for the table. ex. `%{name: %{"$in": ["red", "blue"]}}`
  ## Examples
  
  ```
    > Astra.Rest.search_table("test", "thing", %{name: %{"$eq": "test row"}}) 
  ```
  
  """
  @spec search_table(String, String, Map) :: {Atom, []}
  def search_table(keyspace, table, query), do: Http.get("#{keyspace}/#{table}",[], params: %{where: Http.json!(query)}) |> Http.parse_response
end
