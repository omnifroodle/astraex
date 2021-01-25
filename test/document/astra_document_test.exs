defmodule AstraDocumentTest do
  use ExUnit.Case
  doctest Astra.Document
  require UUID
  
  describe "posts" do
    test "a document" do
      doc = %{ 
        name: "some-stuff",
        other: "This makes no sense"
      }
      assert {:ok, _} = Astra.Document.post_doc("test", "docs", doc)
    end
  end
  
  describe "gets" do
    test "a document" do
      doc = %{ 
        name: "other-stuff",
        other: "This makes no sense"
      }
      {:ok, %{documentId: id}} = Astra.Document.post_doc("test", "docs", doc)
      assert {:ok, ^doc} = Astra.Document.get_doc("test", "docs", id)
    end
    
      
    test "a sub-doc" do
      doc = %{ 
        name: "other-stuff",
        other: %{ first: "thing", last: "thing"}
      }
      {:ok, %{documentId: id}} = Astra.Document.post_doc("test", "docs", doc)
      assert {:ok, %{ first: "thing", last: "thing"}} = Astra.Document.get_sub_doc("test", "docs", id, "other")
    end
    
    test "a doc via search" do
      uuid = UUID.uuid1()
      doc = %{ 
        name: "where-stuff",
        other: uuid
      }
      {:ok, %{documentId: id}} = Astra.Document.post_doc("test", "docs", doc)
      query = %{
        other: %{
          "$eq": uuid
        }
      }
      
      {:ok, results} = Astra.Document.search_docs("test", "docs", query, %{"page-size": 20})
      assert Map.has_key?(results, String.to_atom(id))
    end
  end
  
  describe "deletes" do
    test "a doc" do
      doc = %{ 
        name: "other-stuff",
        other: "This makes no sense"
      }
      {:ok, %{documentId: id}} = Astra.Document.post_doc("test", "docs", doc)
      assert {:ok, []} = Astra.Document.delete_doc("test", "docs", id)
    end
    
    test "a sub-doc" do
      doc = %{ 
        name: "other-stuff",
        other: %{ first: "thing", last: "thing"}
      }
      {:ok, %{documentId: id}} = Astra.Document.post_doc("test", "docs", doc)
      assert {:ok, []} = Astra.Document.delete_sub_doc("test", "docs", id, "other/first")
    end
  end
  
  describe "patches" do
    test "a sub-doc" do  
      doc = %{ 
        name: "other-stuff",
        other: %{ first: "thing", last: "thing"}
      }
      {:ok, %{documentId: id}} = Astra.Document.post_doc("test", "docs", doc)
      {:ok, nil} = Astra.Document.patch_sub_doc("test", "docs", id, "other", %{first: "object"})
      assert {:ok, %{name: "other-stuff", other: %{first: "object", last: "thing"}}} = Astra.Document.get_doc("test", "docs", id)
    end
    
    test "a doc" do  
      doc = %{ 
        name: "other-stuff",
        other: %{ first: "thing", last: "thing"}
      }
      {:ok, %{documentId: id}} = Astra.Document.post_doc("test", "docs", doc)
      {:ok, nil} = Astra.Document.patch_doc("test", "docs", id,  %{name: "fred"})
      assert {:ok, %{name: "fred", other: %{first: "thing", last: "thing"}}} = Astra.Document.get_doc("test", "docs", id)
    end
  end
  
  describe "puts" do
    test "a sub-doc" do  
      doc = %{ 
        name: "other-stuff",
        other: %{ first: "thing", last: "thing"}
      }
      {:ok, %{documentId: id}} = Astra.Document.post_doc("test", "docs", doc)
      {:ok, nil} = Astra.Document.put_sub_doc("test", "docs", id, "other", %{first: "object"})
      assert {:ok, %{name: "other-stuff", other: %{first: "object"}}} = Astra.Document.get_doc("test", "docs", id)
    end
    
    test "a doc" do
      uuid = UUID.uuid1()
      doc = %{ 
        name: "other-stuff",
        other: %{ first: "thing", last: "thing"}
      }
      {:ok, _} = Astra.Document.put_doc("test", "docs", uuid, doc)
      assert {:ok, doc} = Astra.Document.get_doc("test", "docs", uuid)
    end
  end
end