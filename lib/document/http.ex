defmodule Astra.Document.Http do
  @moduledoc """
  `Astra.Document.Http` provides direct access to all HTTP methods implemented in `HTTPoison`.  It is used by `Astra.Document` to add required headers and security to request, but could also be used to directly access unimplemented functionality in the future.
  """
  use HTTPoison.Base
  use Astra.HttpBase

  # using atoms in a schemaless database is not safe, revert to strings
  def parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, Map.get(Jason.decode!(body), "data")}
  def parse_response({:ok, %HTTPoison.Response{status_code: 201, body: body}}), do: {:ok, Jason.decode!(body)}
  def parse_response({:ok, %HTTPoison.Response{status_code: 204}}), do: {:ok, []}

  def parse_response({:ok, %HTTPoison.Response{status_code: 401}}), do: {:rejected, "unauthorized"}
  def parse_response({:ok, %HTTPoison.Response{status_code: 409}}), do: {:rejected, "duplicate"}

  #fallback
  def parse_response(resp) do
    Logger.warn "error from Astra: #{inspect resp}"
    {:error, resp}
  end

  # override the default url to deal with path and port differences between
  # Astra and Stargate
  def process_request_url(sub_path) do
    config = Application.get_all_env(:astra)
    uri = port_and_path(config[:host], 8082) <> sub_path

    Logger.debug """
      URI: #{inspect(uri)}
      Config: #{inspect(config)}
    """
    uri
  end

  # Astra port and path
  def port_and_path(nil, _port), do: Astra.HttpBase.url_base() <> "/api/v2/namespaces/"
  # Stargate port and path
  def port_and_path(host, port) do
    URI.parse("http://" <> host) |>
    Map.merge(%{port: port, path: "/v2/namespaces/"}) |>
    URI.to_string
  end
end
