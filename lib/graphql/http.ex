defmodule Astra.Graphql.Http do
  @moduledoc """
  `Astra.Graphql.Http` provides direct access to all HTTP methods implemented in `HTTPoison`.  It is used by `Astra.Graphql` to add required headers and security to request, but could also be used to directly access unimplemented functionality in the future.
  """
  use HTTPoison.Base
  use Astra.HttpBase, path: "graphql" 
  
  # modify the default headers for graphql
  def process_request_headers(headers) do
    {:ok, token} = Astra.TokenManager.get_token
    headers ++ [{"Content-Type", "application/graphql"},
                {"accept", "application/json"},
                {"x-cassandra-token", token},
                {"User-Agent", Astra.HttpBase.user_agent()}]
  end
end