defmodule Astra.Auth do
  alias Astra.Auth.Http
  
  @doc """
  Get a fresh auth token from Astra. Automatically called by the TokenManager app
  
  ## Parameters
  
    - username: Astra database user name
    - password: password for the user
    
  ## Examples
  
  ```
    > Astra.Auth.authorize_user("operator", "bad_password!")
    {:ok, %{authToken: "3f9d03af-e29d-40d5-9fe1-c77a2ff6a40a"}}
  ```
  
  """
  @spec authorize_user(String, String) :: {Atom, Map}
  def authorize_user(username, password) do
    body = %{ 
      username: username,
      password: password
    }
    Http.post("auth", Http.json!(body)) |> Http.parse_response
  end
  
end