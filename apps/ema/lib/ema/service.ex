defmodule Ema.Service do
  @callback init([term]) :: {:ok, term} | {:error, String.t()}
  @callback action(atom, term, term) :: {:ok, term} | {:error, String.t()}

  def run(service, action, args) do
    # TODO: properly store state
    state = %{}
    service.action(action, args, state)
  end

  defmacro __using__(_opts) do
    quote do
      @behaviour Ema.Service
      import Ema.Service
    end
  end

  defmacro action(act, input, response, do: body) do
    # TODO check input is correct

    # TODO store input and response in ets or something

    # Not really sure why this works
    args = Macro.escape({:args, [], nil})
    body = Macro.escape(body, unquote: true)

    quote bind_quoted: [act: act, args: args, body: body] do
      def action(unquote(act), unquote(args), state) do
        unquote(body)
      end
    end
  end
end
