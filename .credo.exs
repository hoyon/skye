%{
  configs: [
    %{
      name: "default",
      files: %{
        excluded: [~r"/assets/", ~r"/_build", ~r"/deps/"]
      },
      strict: true,
      color: true,
      checks: [
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 100},
        {Credo.Check.Readability.ModuleDoc, false},
        {Credo.Check.Design.AliasUsage, false},
        {Credo.Check.Refactor.PipeChainStart, false}
      ]
    }
  ]
}
