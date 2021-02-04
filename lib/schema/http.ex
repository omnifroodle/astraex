defmodule Astra.Schema.Http do
  @moduledoc """
  `Astra.Schema.Http` provides direct access to all HTTP methods implemented in `HTTPoison`.  It is used by `Astra.Schema` to add required headers and security to request, but could also be used to directly access unimplemented functionality in the future.
  """
  use HTTPoison.Base
  use Astra.HttpBase, path: "rest/v2/schemas/"
  
  def process_request_options(options) do
    options ++ [recv_timeout: :infinity]
  end
end