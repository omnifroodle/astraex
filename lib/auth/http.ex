defmodule Astra.Auth.Http do
  @moduledoc """
  `Astra.Auth.Http` provides direct access to all HTTP methods implemented in `HTTPoison`.  It is used by `Astra.Rest` to add required headers and security to request, but could also be used to directly access unimplemented functionality in the future.
  """
  use HTTPoison.Base
  use Astra.HttpBase

  # override the default headers because we don't need a request id or
  # authorization token here
  def process_request_headers(headers) do
    headers ++ [{"Content-Type", "application/json"},
                {"accept", "application/json"},
                {"User-Agent", Astra.HttpBase.user_agent()}]
  end


  # override the default url to deal with path and port differences between
  # Astra and Stargate
  def process_request_url(sub_path) do
    config = Application.get_all_env(:astra)
    uri = port_and_path(config[:host], 8081) <> sub_path

    Logger.debug """
      URI: #{inspect(uri)}
      Config: #{inspect(config)}
    """
    uri
  end

  # Astra port and path
  def port_and_path(nil, _port), do: Astra.HttpBase.url_base() <> "/api/v1/"
  # Stargate port and path
  def port_and_path(host, port) do
    URI.parse("http://" <> host) |>
    Map.merge(%{port: port, path: "/v1/"}) |>
    URI.to_string
  end

end
