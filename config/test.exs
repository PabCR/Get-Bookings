import Config

config :api_handler, :test,
  http_client: HTTPClientMock,
  url: System.get_env("TEST_API_URL")
