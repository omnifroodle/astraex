defmodule Mix.Tasks.Astra.Test do
  
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.shell().info(Enum.join(args, " "))
  end
end