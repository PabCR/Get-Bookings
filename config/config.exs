import Config

config :api_handler, :get_bookings,
  http_client: HTTPoison,
  url: System.get_env("TEST_API_URL"),
  method: :post
