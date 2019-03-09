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
        {Credo.Check.Readability.ModuleDocc, false},
        {Credo.Check.Design.AliasUsage, false},
      ]
    }
  ]
}
