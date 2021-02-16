defmodule Astra.TokenManager do
  @moduledoc false
  use GenServer
  require Logger
  @update_interval 1_700_000

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
    {:ok, get_new_token()}
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
    token = get_new_token()
    Process.send_after(self(), :tick, @update_interval)
    {:noreply, token}
  end

  def get_new_token do
    config = Application.get_all_env(:astra)
    case Astra.Auth.authorize_user(config[:username], config[:password]) do
    {:ok, %{authToken: token}} ->
      {:ok, token}
    other ->
      Logger.warn("Failed to get Astra token, response was: #{inspect(other)}")
      {:error, "something went wrong!"}
    end
  end
end