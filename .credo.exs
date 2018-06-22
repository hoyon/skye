%{
  configs: [
    %{
      name: "default",
      files: %{
        excluded: [~r"/assets/", ~r"/_build", ~r"/deps/"]
      },
      strict: true,
      color: true,
    }
  ]
}
