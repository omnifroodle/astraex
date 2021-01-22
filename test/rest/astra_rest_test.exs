defmodule AstraRestTest do
  use ExUnit.Case
  doctest Astra.Rest
  
  setup_all do
    # create some test data
    read_row = %{id: UUID.uuid4(), name: "test row"}
    Astra.Rest.add_row("test", "thing", read_row)
    
    delete_row = %{id: UUID.uuid4(), name: "test row"}
    Astra.Rest.add_row("test", "thing", delete_row)
    
    #schedule data cleanup
    on_exit(fn ->
      Astra.Rest.delete_row("test", "thing", Map.get(read_row, :id))
      Astra.Rest.delete_row("test", "thing", Map.get(delete_row, :id))
    end)
    %{read_row: read_row, delete_row: delete_row}
  end
  
  test "add a row" do
    uuid = UUID.uuid4()
    on_exit(fn ->
      Astra.Rest.delete_row("test", "thing", uuid)
    end)
    row = %{id: uuid, name: "test row"}
    {:ok, _} = Astra.Rest.add_row("test", "thing", row)
    {:ok, [data | _ ]} = Astra.Rest.get_row("test", "thing", uuid)
    assert ^row = data
  end
  
  test "read a row", %{read_row: row} do
    id = Map.get(row, :id)
    {:ok, [data | _ ]} = Astra.Rest.get_row("test", "thing", id)
    assert ^id = Map.get(data, :id)
  end
  
  test "read a row that doesn't exist" do
    #TODO GET with no row should be a 404!
    uuid = UUID.uuid4()
    assert {:ok, []} = Astra.Rest.get_row("test", "thing", uuid)
  end
  
  test "delete a row", %{delete_row: row} do
    {:ok, _} = Astra.Rest.delete_row("test", "thing", Map.get(row, :id))
    assert {:ok, []} = Astra.Rest.get_row("test", "thing", Map.get(row, :id))
  end
  
  test "search" do
    {:ok, data} = Astra.Rest.search_table("test", "thing", %{name: %{"$eq": "test row"}})  
    assert Enum.count(data) >= 1
  end
  
end
