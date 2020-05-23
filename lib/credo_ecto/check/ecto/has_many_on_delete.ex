defmodule CredoEcto.Check.Ecto.HasManyOnDelete do
  @moduledoc false

  use Credo.Check,
    base_priority: :high,
    tags: [:ecto],
    explanations: [
      check: """
      Checks if ecto schema has set on_delete for has_many associatons.
      """,
      params: []
    ]

  alias Credo.Code

  @doc false
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)
    Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  # Private functions
  defp traverse({:has_many, meta, [_, _, opts]} = ast, issues, issue_meta) do
    if Keyword.has_key?(opts, :on_delete) do
      {ast, issues}
    else
      issues = [issue_for("has_many", issue_meta, meta[:line]) | issues]
      {ast, issues}
    end
  end

  defp traverse({:has_many, meta, [_, _]} = ast, issues, issue_meta) do
    issues = [issue_for("has_many", issue_meta, meta[:line]) | issues]
    {ast, issues}
  end

  defp traverse(ast, issues, _), do: {ast, issues}

  defp issue_for(trigger, issue_meta, line_no) do
    format_issue(
      issue_meta,
      message: "`#{trigger}` should always have an on_delete option to avoid data inconsistencies.",
      trigger: trigger,
      line_no: line_no
    )
  end
end
