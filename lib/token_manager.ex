defmodule Astra.TokenManager do
  @moduledoc false
  use GenServer
  require Logger
  @update_interval 1_700_000
  @config Application.get_all_env(:astra)
  @auth_url "https://#{@config[:id]}-#{@config[:region]}.apps.astra.datastax.com/api/rest"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end
  
  @doc """
  Get Token fetches a security token from Astra for use with other requests.
  """
  def get_token() do
    GenServer.call(__MODULE__, {:get})
  end

  @impl true
  def init(:ok) do
    #schedule a regular update of the security token
    Process.send_after(self(), :tick, @update_interval)
    {:ok, pget_token()}
  end

  @impl true
  def handle_call({:get}, _, token) do
    {:reply, token, token}
  end

  @impl true
  def handle_cast({:set, new_token}, _token) do
    {:noreply, new_token}
  end

  @impl true
  def handle_info(:tick, _) do
    token = pget_token()
    Process.send_after(self(), :tick, @update_interval)
    {:noreply, token}
  end


  defp pget_token do
    case HTTPoison.post "#{@auth_url}/v1/auth",
      "{\"username\": \"#{@config[:username]}\", \"password\": \"#{@config[:password]}\"}",
      [{"Content-Type", "application/json"},
      {"accept", "*/*"},
      {"x-cassandra-request-id", UUID.uuid1()}],
      [ssl: [{:versions, [:'tlsv1.2']}]] do
    {:ok, %HTTPoison.Response{body: body}} ->
      {:ok, Jason.decode!(body)["authToken"]}
    other ->
      Logger.warn("Failed to get Astra token, response was: #{inspect(other)}")
      {:error, "something went wrong!"}
    end
  end
end