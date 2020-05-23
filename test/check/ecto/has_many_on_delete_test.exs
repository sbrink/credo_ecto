defmodule CredoEcto.Check.Ecto.HasManyOnDeleteTest do
  use Credo.Test.Case

  alias CredoEcto.Check.Ecto.HasManyOnDelete

  test "does not report when on_delete is set" do
    """
    defmodule User do
      schema "users" do
        has_many :posts, Post, on_delete: :nothing
      end
    end
    """
    |> to_source_file
    |> run_check(HasManyOnDelete)
    |> refute_issues()
  end

  test "does not report when on_delete is set with multiple options" do
    """
    defmodule User do
      schema "users" do
        has_many :posts, Post, on_delete: :nothing, on_replace: :delete
      end
    end
    """
    |> to_source_file
    |> run_check(HasManyOnDelete)
    |> refute_issues()
  end

  test "does report when on_delete is missing without options" do
    """
    defmodule User do
      schema "users" do
        has_many :posts, Post
      end
    end
    """
    |> to_source_file
    |> run_check(HasManyOnDelete)
    |> assert_issue()
  end

  test "does report when on_delete is missing with options" do
    """
    defmodule User do
      schema "users" do
        has_many :posts, Post, on_replace: :delete
      end
    end
    """
    |> to_source_file
    |> run_check(HasManyOnDelete)
    |> assert_issue()
  end
end
