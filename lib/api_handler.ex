defmodule GetBookings do
  @moduledoc """
  Documentation for `GetBookings`.
  """

  def fetch_data(url) do
    token = "9e3011c7-e012-4f42-94af-9ed6234d3dd6"
    headers = [{"Authorization", "Bearer #{token}"}]

    case HTTPoison.request(:post, url, "", headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:not_found, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
