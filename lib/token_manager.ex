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
    config = Application.get_all_env(:astra)
    {:ok, get_current_token(config[:username], config[:password], config[:application_token])}
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
    config = Application.get_all_env(:astra)
    token = get_current_token(config[:username], config[:password], nil)
    Process.send_after(self(), :tick, @update_interval)
    {:noreply, token}
  end

  #fetch a token from the server and schedule a regular update of the security token
  def get_current_token(username, password, nil) do
    Process.send_after(self(), :tick, @update_interval)
    case Astra.Auth.authorize_user(username, password) do
      {:ok, %{authToken: token}} ->
        {:ok, token}
      other ->
        Logger.warn("Failed to get Astra token, response was: #{inspect(other)}")
        {:error, "something went wrong!"}
    end
  end
  
  #use a static app token, used when app token is provided in the config
  def get_current_token(_,_,token), do: {:ok, token}
end