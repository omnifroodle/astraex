defmodule Astra.Auth.Http do
  @moduledoc """
  `Astra.Auth.Http` provides direct access to all HTTP methods implemented in `HTTPoison`.  It is used by `Astra.Rest` to add required headers and security to request, but could also be used to directly access unimplemented functionality in the future.
  """
  use HTTPoison.Base
  use Astra.HttpBase, path: "v1/" 
  
  # override the default headers because we don't need a request id or
  # authorization token here
  def process_request_headers(headers) do
    headers ++ [{"Content-Type", "application/json"},
                {"accept", "application/json"},
                {"User-Agent", Astra.HttpBase.user_agent()}]
  end
end