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


  # override the default url to deal with path and port differences between
  # Astra and Stargate
  def process_request_url(sub_path) do
    config = Application.get_all_env(:astra)
    uri = port_and_path(config[:host], 8080) <> sub_path

    Logger.debug """
      URI: #{inspect(uri)}
      Config: #{inspect(config)}
    """
    uri
  end

  # Astra port and path
  def port_and_path(nil, _port), do: Astra.HttpBase.url_base() <> "/api/graphql"
  # Stargate port and path
  def port_and_path(host, port) do
    URI.parse("http://" <> host) |>
    Map.merge(%{port: port, path: "/graphql"}) |>
    URI.to_string
  end
end
