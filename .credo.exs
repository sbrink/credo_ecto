%{
  configs: [
    %{
      name: "default",
      checks: [
        {CredoEcto.Check.Ecto.HasManyOnDelete, []},
        {CredoEcto.Check.Ecto.StringLengthValidation, []}
      ]
    }
  ]
}
