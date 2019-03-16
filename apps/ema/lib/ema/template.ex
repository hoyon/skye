defmodule Ema.Template.Helpers do
  import NimbleParsec

  def expression do
    ignore(string("{{"))
    |> ascii_string([?0..?9, ?a..?z, ?A..?Z, ?\s, ?_], min: 1)
    |> ignore(string("}}"))
  end

  def until_brace(c \\ empty()) do
    repeat_while(c, utf8_char([]), {:not_brace, []})
  end

  def not_brace(<<?{, ?{, _::binary>>, context, _, _), do: {:halt, context}
  def not_brace(<<?}, ?}, _::binary>>, context, _, _), do: {:halt, context}
  def not_brace(_, context, _, _), do: {:cont, context}
end

defmodule Ema.Template do
  import NimbleParsec
  import Ema.Template.Helpers

  template =
    repeat(
      optional(until_brace())
      |> concat(expression())
    )
    |> optional(until_brace())
    |> eos()

  defparsec(:template, template)

  def parse(input) do
    with {:ok, symbols} <- parse_symbols(input) do
      ast = accumulate_symbols(symbols)
      {:ok, ast}
    else
      {:error, e} ->
        {:error, e}
    end
  end

  defp parse_symbols(input) do
    case template(input) do
      {:ok, matched, "", _, _, _} ->
        {:ok, matched}

      {:error, msg, _, _, _, _} ->
        {:error, "Failed to parse template: #{msg}"}
    end
  end

  defp accumulate_symbols(symbols) do
    {ast, rest} = Enum.reduce(symbols, {[], []}, &symbol_reducer/2)

    if rest != [] do
      ast ++ [{:str, to_string(rest)}]
    else
      ast
    end
  end

  defp symbol_reducer(token, {ast, str}) when is_integer(token) do
    {ast, str ++ [token]}
  end
  defp symbol_reducer(token, {ast, []}) when is_binary(token) do
    {ast ++ [{:expr, String.trim(token)}], []}
  end
  defp symbol_reducer(token, {ast, str}) when is_binary(token) do
    {ast ++ [{:str, to_string(str)}, {:expr, String.trim(token)}], []}
  end
end
