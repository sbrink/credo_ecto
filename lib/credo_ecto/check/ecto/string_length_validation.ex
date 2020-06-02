defmodule CredoEcto.Check.Ecto.StringLengthValidation do
  @moduledoc false

  use Credo.Check,
    base_priority: :high,
    tags: [:ecto],
    explanations: [
      check: """
      Checks if every field of type string has a length validator.
      """,
      params: []
    ]

  alias Credo.Code

  @doc false
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)
    string_fields = Code.prewalk(source_file, &find_schema(&1, &2))

    if Enum.any?(string_fields) do
      validation_fields = Credo.Code.prewalk(source_file, &find_validation_field(&1, &2), [])

      string_fields
      |> Enum.filter(fn {field, _} -> field not in validation_fields end)
      |> Enum.map(fn {field, meta} -> issue_for(field, issue_meta, meta[:line]) end)
      |> IO.inspect()
    else
      []
    end
  end

  # Private functions
  defp find_schema({:schema, _meta, _} = ast, _) do
    string_fields = Credo.Code.prewalk(ast, &find_string_field(&1, &2), [])
    {ast, string_fields}
  end

  defp find_schema(ast, string_fields), do: {ast, string_fields}

  defp find_string_field({:field, meta, [field_name, :string | _]} = ast, string_fields) do
    {ast, [{field_name, meta} | string_fields]}
  end

  defp find_string_field(ast, string_fields), do: {ast, string_fields}

  defp find_validation_field({:validate_length, _meta, [field_name | _]} = ast, string_fields) do
    {ast, [field_name | string_fields]}
  end

  defp find_validation_field(ast, string_fields), do: {ast, string_fields}

  defp issue_for(trigger, issue_meta, line_no) do
    format_issue(
      issue_meta,
      message: "`#{trigger}` should always have a length validator.",
      trigger: trigger,
      line_no: line_no
    )
  end
end
