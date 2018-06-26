defmodule Ema.Service do
  @callback init([term]) :: {:ok, term} | {:error, String.t()}
  @callback action(atom, term, term) :: {:ok, term} | {:error, String.t()}

  @action_prefix "__ema_action_"

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

  defmacro action(act, input, output, do: body) do
    fun_name = :"#{@action_prefix}#{act}"

    info_ast = quote do
      def unquote(fun_name)() do
        %{action: unquote(act), input: unquote(input), response: unquote(output)}
      end
    end

    # Not really sure why this works
    args = Macro.escape({:args, [], nil})
    body = Macro.escape(body, unquote: true)

    act_ast = quote bind_quoted: [fun_name: fun_name, act: act, args: args, body: body] do

      def action(unquote(act), unquote(args), state) do
        unquote(body)
      end
    end

    [info_ast, act_ast]
  end

  def actions(service) when is_atom(service) do
    service.__info__(:functions)
    |> Enum.filter(fn {fun, arity} ->
      String.starts_with?("#{fun}", @action_prefix) and arity == 0
    end)
    |> Enum.map(fn {fun, 0} ->
      name = String.replace_prefix("#{fun}", @action_prefix, "")
      info = apply(service, fun, [])
      {name, info}
    end)
  end

end
