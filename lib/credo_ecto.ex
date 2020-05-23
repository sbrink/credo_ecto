defmodule CredoEcto do
  @moduledoc false
  @config_file File.read!(".credo.exs")

  import Credo.Plugin

  def init(exec) do
    exec
    |> register_default_config(@config_file)
  end
end
