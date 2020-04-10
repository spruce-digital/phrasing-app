defmodule Phrasing.Account.Form do
  use Ecto.Schema
  import Ecto.Changeset

  alias Phrasing.Account.{User, Profile, UserLanguage, Form}

  embedded_schema do
    # Account.User
    field :email, :string

    # Account.Profile
    field :profile_id, :integer
    field :birthday, :date
    field :gender, :string
    field :name, :string

    # Account.UserLanguage
    field :native_languages, {:array, :string}, default: []
    field :learning_languages, {:array, :string}, default: []
  end

  @allowed_fields [:email, :birthday, :gender, :name, :native_languages, :learning_languages]

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, @allowed_fields)
  end

  def changeset_from_user(%Form{} = form, %User{} = user) do
    %Form{
      email: user.email,
      profile_id: user.profile.id,
      birthday: to_date(user.profile.birthday),
      gender: user.profile.gender,
      name: user.profile.name,
      native_languages:
        user.user_languages
        |> Enum.filter(&(&1.level > 50))
        |> Enum.map(& &1.language_id),
      learning_languages:
        user.user_languages
        |> Enum.filter(&(&1.level <= 50))
        |> Enum.map(& &1.language_id)
    }
    |> cast(%{}, @allowed_fields)
  end

  def user_changeset(%User{} = user, attrs) do
    form = Form.changeset(%Form{}, attrs)

    native_uls =
      form
      |> get_change(:native_languages)
      |> to_user_languages(user, level: 100)

    learning_uls =
      form
      |> get_change(:learning_languages)
      |> to_user_languages(user, level: 0)

    User.changeset(user, %{
      email: get_change(form, :email),
      profile: %{
        id: get_change(form, :profile_id),
        birthday: to_date(get_change(form, :birthday)),
        gender: get_change(form, :gender),
        name: get_change(form, :name)
      },
      user_languages: native_uls ++ learning_uls
    })
  end

  def to_user_languages(language_ids, user, level: level) do
    language_ids
    |> Enum.map(fn id ->
      case Enum.find(user.user_languages, &(to_string(&1.language_id) == id)) do
        %UserLanguage{} = user_language ->
          %{user_language | level: level}

        nil ->
          %UserLanguage{user_id: user.id, language_id: id, level: level}
      end
    end)
  end

  def to_date(nil), do: nil
  def to_date(%Date{} = date), do: date
  def to_date(string), do: Date.from_iso8601!(string)
end
