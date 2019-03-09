defmodule TestService do
  use Ema.Service

  name "test service"
  description "test description"

  action :echo, :string, :string do
    {:ok, input}
  end

end
