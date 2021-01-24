defmodule Astra.Schema do
  @moduledoc false
  use HTTPoison.Base
  use Astra.HttpBase
  #@url "rest/v2/schemas/keyspaces"
  
  #TODO this might be even cleaner if we "use" instead of "import"
  # def process_request_url(url), do: base_request_url() <> @url <> url
  # def process_request_headers(headers), do: base_request_headers(headers)
  # def process_request_options(options), do: base_request_options(options)
 
  def keyspaces(), do: get("") |> parse_response

end