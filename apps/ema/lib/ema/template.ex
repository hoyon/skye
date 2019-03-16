defmodule Ema.Template do
  import NimbleParsec

  expression =
    ignore(string("{{"))
    |> ascii_string([?0..?9, ?a..?z, ?A..?Z, ?\s, ?_], min: 1)
    |> ignore(string("}}"))

  template =
    repeat(
      repeat_while(utf8_char([]), {:not_brace, []})
      |> concat(expression)
      |> repeat_while(utf8_char([]), {:not_brace, []})
    ) |> eos()

  defp not_brace(<<?{, _::binary>>, context, _, _), do: {:halt, context}
  defp not_brace(_, context, _, _), do: {:cont, context}

  defparsec :template, template
end
