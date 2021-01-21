defmodule Astra.Rest do
  alias Astra.Rest.Http
  @moduledoc """
  `Astra.Rest` provides functions to access the public methods of the REST interface for Astra.
  Astra's REST interface is implemented using the stargate project, https://stargate.io.  Swagger docs for this interface are available here https://docs.astra.datastax.com/reference#keyspaces-2.
  
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
  lazy create using POST, no explicit key required (though it must still exist in the entity)

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
  @spec search_table(String, String, Map) :: {Atom, []}
  def search_table(keyspace, table, query), do: Http.get("#{keyspace}/#{table}", Http.json!(query)) |> Http.parse_response
end
