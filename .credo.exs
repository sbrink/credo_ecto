%{
  configs: [
    %{
      name: "default",
      checks: [
        {CredoEcto.Check.Ecto.HasManyOnDelete, []}
      ]
    }
  ]
}
