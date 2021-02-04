defmodule Astra.HttpBase do
  @moduledoc false
  @config Application.get_all_env(:astra)

  
  defmacro __using__(opts) do
    
    path = Keyword.get(opts, :path, "")
    url = "https://#{@config[:id]}-#{@config[:region]}.apps.astra.datastax.com/api/"

    quote do
      require Logger
      def parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, Map.get(Jason.decode!(body, keys: :atoms), :data)}
      def parse_response({:ok, %HTTPoison.Response{status_code: 201, body: body}}), do: {:ok, Jason.decode!(body, keys: :atoms)}
      def parse_response({:ok, %HTTPoison.Response{status_code: 204}}), do: {:ok, []}
      
      def parse_response({:ok, %HTTPoison.Response{status_code: 401}}), do: {:rejected, "unauthorized"}
      def parse_response({:ok, %HTTPoison.Response{status_code: 409}}), do: {:rejected, "duplicate"}
      
      #fallback
      def parse_response(resp) do 
        Logger.warn "error from Astra: #{inspect resp}"
        {:error, resp}
      end
      
      def process_request_url(sub_path), do: unquote(url <> path) <> sub_path
      
      def process_request_headers(headers) do
        {:ok, token} = Astra.TokenManager.get_token
        headers ++ [{"Content-Type", "application/json"},
                    {"accept", "application/json"},
                    {"x-cassandra-token", token},
                    {"x-cassandra-request-id", UUID.uuid1()}]
      end
      
      def process_request_options(options), do: options ++ [ssl: [{:versions, [:'tlsv1.2']}]]
      
      def json!(entity) do 
        {:ok, body} = Jason.encode(entity)
        body
      end
      defoverridable Module.definitions_in(__MODULE__)
    end
  end
end