defmodule APIHandler do
  @moduledoc """
  Documentation for `APIHandler`.
  """
  @callback get_bookings(String.t()) ::
              {:ok, map()} | {:not_found, String.t()} | {:error, String.t()}
  def get_bookings(url_domain, config \\ default_config()) do
    url = Keyword.get(config, :url, "") <> url_domain
    token = System.get_env("TEST_API_TOKEN")
    headers = [{"Authorization", "Bearer #{token}"}]
    method = Keyword.get(config, :method)
    http_client = Keyword.get(config, :http_client)

    method
    # |> IO.inspect()
    |> http_client.request(url, "", headers)
    # |> IO.inspect()
    |> handle()
  end

  defp handle({:ok, %HTTPoison.Response{body: body, status_code: 200}}), do: Jason.decode(body)
  defp handle({:not_found, _}), do: {:not_found, "Not found"}
  defp handle(_), do: {:error, "something went wrong"}

  def default_config() do
    Application.fetch_env!(:api_handler, :get_bookings)
  end
end
