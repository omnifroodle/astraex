defmodule Astra.Document.Http do
  @moduledoc """
  `Astra.Document.Http` provides direct access to all HTTP methods implemented in `HTTPoison`.  It is used by `Astra.Document` to add required headers and security to request, but could also be used to directly access unimplemented functionality in the future.
  """
  use HTTPoison.Base
  use Astra.HttpBase, path: "rest/v2/namespaces/" 
end