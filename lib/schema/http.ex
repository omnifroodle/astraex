defmodule Astra.Schema.Http do
  @moduledoc """
  `Astra.Schema.Http` provides direct access to all HTTP methods implemented in `HTTPoison`.  It is used by `Astra.Schema` to add required headers and security to request, but could also be used to directly access unimplemented functionality in the future.
  """
  use HTTPoison.Base
  use Astra.HttpBase

  def process_request_options(options) do
    options ++ [recv_timeout: :infinity]
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
  def port_and_path(nil, _port), do: Astra.HttpBase.url_base() <> "/api/v2/schemas/"
  # Stargate port and path
  def port_and_path(host, port) do
    URI.parse("http://" <> host)
    |> Map.merge(%{port: port, path: "/v2/schemas/"})
    |> URI.to_string
  end
end
