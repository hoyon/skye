defmodule Ema.Service.Placeholder.Api do
  @callback get_post(number) :: term()
  @callback get_user(number) :: term()
end
