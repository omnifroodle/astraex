defmodule Astra.Document do
  alias Astra.Document.Http
  @moduledoc """
  Provides functions to access the public methods of the Document API for databases hosted on https://astra.datastax.com. 
  
  Astra's Document API is implemented using the stargate project, https://stargate.io. Swagger docs for this interface are available here https://docs.astra.datastax.com/reference#namespaces-1.
  
  If required, raw access to the Astra REST Document API can be obtained through the `Astra.Document.Http` module.
  
  """
  
  @doc """
  update part of a document
  
  ## Parameters
  
    - namespace: namespace name
    - collection: name of the document collection
    - id: the id of the document
    

  ## Examples
  
  ```
    > Astra.Document.patch_doc("test", "docs", id,  %{name: "fred"})
    {:ok, nil}
  ```
  
  """
  @spec patch_doc(String, String, String, Map) :: {Atom, nil}
  def patch_doc(namespace, collection, id, patch), do: Http.patch("#{namespace}/collections/#{collection}/#{id}", Http.json!(patch)) |> Http.parse_response

  @doc """
  update part of a sub document
  
  ## Parameters
  
    - namespace: namespace name
    - collection: name of the document collection
    - id: the id of the document'
    - path: the path to the subdocument. Nested paths can be matched by joining the keys with a `\\`, ex. `address\\city` 
    - patch: a map of attributes to match.  Sub-document attributes not in the patch Map will remain as is.

  ## Examples
  
  ```
    > Astra.Document.patch_sub_doc("test", "docs", id, "other", %{first: "object"})
    {:ok, nil}
  ```
  
  """
  @spec patch_sub_doc(String, String, String, String, Map) :: {Atom, nil}
  def patch_sub_doc(namespace, collection, id, path, patch), do: Http.patch("#{namespace}/collections/#{collection}/#{id}/#{path}", Http.json!(patch)) |> Http.parse_response
  
  @doc """
  replace a document
  
  ## Parameters
  
    - namespace: namespace name
    - collection: name of the document collection
    - id: the id of the document
    - doc: the new document. Any existing document at the id will be removed.
    
  ## Examples
  
  ```
    > doc = %{ 
        name: "other-stuff",
        other: %{ first: "thing", last: "thing"}
      }
    > Astra.Document.put_doc("test", "docs", uuid, doc)
  ```
  
  """
  @spec put_doc(String, String, String, Map) :: {Atom, Map}
  def put_doc(namespace, collection, id, doc), do: Http.put("#{namespace}/collections/#{collection}/#{id}", Http.json!(doc)) |> Http.parse_response

  @doc """
  replace a sub document
  
  ## Parameters
  
    - namespace: namespace name
    - collection: name of the document collection
    - id: the id of the document
    - path: the path to the subdocument. Nested paths can be matched by joining the keys with a `\\`, ex. `address\\city` 
    - doc: the new document. Any existing document at the id will be removed.
    
  ## Examples
  
  ```
    > doc = %{ 
        name: "other-stuff",
        other: %{ first: "thing", last: "thing"}
      }
    > Astra.Document.put_doc("test", "docs", uuid, doc)
  ```
  
  """
  @spec put_sub_doc(String, String, String, String, Map) :: {Atom, Map}
  def put_sub_doc(namespace, collection, id, path, subdoc), do: Http.put("#{namespace}/collections/#{collection}/#{id}/#{path}", Http.json!(subdoc)) |> Http.parse_response

  @doc """
  add a new document, id will be an auto generated uuid
  
  ## Parameters
  
    - namespace: namespace name
    - collection: name of the document collection
    - doc: the new document. 
    
  ## Examples
  
  ```
    > doc = %{ 
        name: "other-stuff",
        other: %{ first: "thing", last: "thing"}
      }
    > Astra.Document.post_doc("test", "docs", doc)
    {:ok, %{documentId: "3f9d03af-e29d-40d5-9fe1-c77a2ff6a40a"}}
  ```
  
  """
  @spec post_doc(String, String, Map) :: {Atom, Map}
  def post_doc(namespace, collection, document), do: Http.post("#{namespace}/collections/#{collection}", Http.json!(document)) |> Http.parse_response
  
  @doc """
  
  get a document by id
  
  ## Parameters
  
    - namespace: namespace name
    - collection: name of the document collection
    - id: the id of the document to retrieve 
    
  ## Examples
  
  ```
    > Astra.Document.get_doc("test", "docs", id)
    {:ok, %{name: "other-stuff", other: "This makes no sense"}}
  ```
  
  """
  @spec get_doc(String, String, String) :: {Atom, Map}
  def get_doc(namespace, collection, id), do: Http.get("#{namespace}/collections/#{collection}/#{id}") |> Http.parse_response

  @doc """
  
  get a sub document by id
  
  ## Parameters
  
    - namespace: namespace name
    - collection: name of the document collection
    - id: the id of the document to retrieve
    - path: the path to the subdocument. Nested paths can be matched by joining the keys with a `\\`, ex. `address\\city` 

    
  ## Examples
  
  ```
    doc = %{ 
      name: "other-stuff",
      other: %{ first: "thing", last: "thing"}
    }
    > {:ok, %{documentId: id}} = Astra.Document.post_doc("test", "docs", doc)
    > Astra.Document.get_sub_doc("test", "docs", id, "other")
    {:ok, %{ first: "thing", last: "thing"}}
  ```
  
  """
  @spec get_sub_doc(String, String, String, String) :: {Atom, Map}
  def get_sub_doc(namespace, collection, id, path), do: Http.get("#{namespace}/collections/#{collection}/#{id}/#{path}") |> Http.parse_response

  @doc """
  
  delete a document
  
  ## Parameters
  
    - namespace: namespace name
    - collection: name of the document collection
    - id: the id of the document to destroy
    
  ## Examples
  
  ```
    > Astra.Document.delete_doc("test", "docs", id)
    {:ok, []}
  ```
  
  """
  @spec delete_doc(String, String, String) :: {Atom, []}
  def delete_doc(namespace, collection, id), do: Http.delete("#{namespace}/collections/#{collection}/#{id}") |> Http.parse_response
  
  @doc """
  
  delete a sub document
  
  ## Parameters
  
    - namespace: namespace name
    - collection: name of the document collection
    - id: the id of the document to destroy
    - path: the path to the subdocument. Nested paths can be matched by joining the keys with a `\\`, ex. `address\\city` 

    
  ## Examples
  
  ```
    doc = %{ 
      name: "other-stuff",
      other: %{ first: "thing", last: "thing"}
    }
    > {:ok, %{documentId: id}} = Astra.Document.post_doc("test", "docs", doc)
    > Astra.Document.get_sub_doc("test", "docs", id, "other")
    {:ok, %{ first: "thing", last: "thing"}}
  ```
  
  """
  @spec delete_sub_doc(String, String, String, String) :: {Atom, []}
  def delete_sub_doc(namespace, collection, id, path), do: Http.delete("#{namespace}/collections/#{collection}/#{id}/#{path}") |> Http.parse_response
    
  @doc """
  
  search for documents in a collection
  
  ## Parameters
  
    - namespace: namespace name
    - collection: name of the document collection
    - where: search clause for matching documents
    - options: Valid options [:fields, :"page-size", :"page-state", :sort]

  ## Examples
  
  ```
    > query = %{
      other: %{
        "$eq": uuid
      }
    }
    > Astra.Document.search_docs("test", "docs", query, %{"page-size": 20})
  ```
  
  """
  @spec search_docs(String, String, Map, Map) :: {Atom, Map}
  def search_docs(namespace, collection, where, options) do
    params = Map.take(options, [:fields, :"page-size", :"page-state", :sort])
      |> Map.put(:where, Http.json!(where))

    Http.get("#{namespace}/collections/#{collection}",[], params: params)
      |> Http.parse_response
  end
end