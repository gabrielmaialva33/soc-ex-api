defmodule SocExApiWeb.AuthJSON do
  alias SocExApiWeb.UserJSON

  @doc """
  Renders a auth data.
  """
  def sign_in(%{user: user, jwt: jwt, claims: claims}) do
    %{
      status: :ok,
      message:
        "You are successfully logged in! Add this token to authorization header to make authorized requests.",
      user: UserJSON.render(%{user: user}),
      auth: data(jwt, claims)
    }
  end

  def sign_up(%{user: user, jwt: jwt, claims: claims}) do
    %{
      status: :ok,
      message:
        "You are successfully signed up! Add this token to authorization header to make authorized requests.",
      user: UserJSON.render(%{user: user}),
      auth: data(jwt, claims)
    }
  end

  defp data(token, claims) do
    %{token: token, claims: claims}
  end
end
