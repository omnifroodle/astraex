defmodule Astra.Schema.Document do
  alias Astra.Schema.Http
  @moduledoc """
  Functions for working with the document (aka namespace) schema APIs
  
  """
  
  
  @doc """
  retrieve a list of all namespaces in the cluster
  
  """
  def get_namespaces, do: Http.get("namespaces") |> Http.parse_response
  
  
  # the following methods should be correct based on the API spec, but
  # something is out of order between the spec and the implementation
  
  # def create_namespace(namespace), do: Http.post("namespaces", "{\"name\": \"#{namespace}\"}") |> Http.parse_response
  
  # def get_collections(namespace), do: Http.get("keyspaces/#{namespace}/collections") |> Http.parse_response
  
  # def create_collection(namespace, collection), do: Http.post("namespaces/#{namespace}/collections", "{\"name\": \"#{collection}\"}") |> Http.parse_response


end