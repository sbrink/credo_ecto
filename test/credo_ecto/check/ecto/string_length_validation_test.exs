defmodule CredoEcto.Check.Ecto.StringLengthValidationTest do
  use Credo.Test.Case

  alias CredoEcto.Check.Ecto.StringLengthValidation

  test "does not report when has_many is not in schema" do
    """
    defmodule User do
      schema "users" do
        field :first_name, :string
        field :last_name, :string, source: :surname
        field :age, :integer
      end

      def changeset(user, attrs) do
        user
        |> cast(attrs, @fields)
        |> validate_length(:first_name, max: 42)
      end
    end
    """
    |> to_source_file
    |> run_check(StringLengthValidation)
    |> assert_issue()
  end
end
