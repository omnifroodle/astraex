defmodule Astra.Rest do
  @config Application.get_all_env(:astra)
  use HTTPoison.Base

  @url "https://#{@config[:id]}-#{@config[:region]}.apps.astra.datastax.com/api/rest/v2/keyspaces/#{@config[:keyspace]}/"

  #TODO normalize this with astra headers in Namespace
  def process_request_url(url), do: @url <> url

  #TODO normalize this with astra headers in Namespace
  def process_request_headers(headers) do
    {:ok, token} = Astra.TokenManager.get_token
    headers ++ [{"Content-Type", "application/json"},
                {"accept", "application/json"},
                {"x-cassandra-token", token},
                {"x-cassandra-request-id", UUID.uuid1()}]
  end

  def process_request_options(options), do: options ++ [ssl: [{:versions, [:'tlsv1.2']}]]

  def read(table, primary_key), do: {_, %{data: _ }} = get("#{table}/#{primary_key}") |> parse_response

  # create using an explicit PUT
  def create(table, key, entity) do
    {:ok, body} = Jason.encode(entity)
    put("#{table}/#{key}", body)
      |> parse_response
  end

  # lazy create using POST, no explicit key required (though it must still exist in the entity)
  def create(table, entity) do
    {:ok, body} = Jason.encode(entity)
    post("#{table}", body)
      |> parse_response
  end
  
  # update uses a patch semantic
  def update(table, key, changes) do
    {:ok, body} = Jason.encode(changes)
    patch("#{table}/#{key}", body)
      |> parse_response
  end
  
  # update uses a patch semantic
  def destroy(table, key), do: delete("#{table}/#{key}") |> parse_response
  
  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, Jason.decode!(body, keys: :atoms)}
  defp parse_response({:ok, %HTTPoison.Response{status_code: 201, body: body}}), do: {:ok, Jason.decode!(body, keys: :atoms)}

  defp parse_response({:ok, %HTTPoison.Response{status_code: 204}}), do: {:miss, %{data: {}}}
  defp parse_response({:ok, %HTTPoison.Response{status_code: 409}}), do: {:rejected, "duplicate"}
  defp parse_response(resp), do: {:error, resp}

end
