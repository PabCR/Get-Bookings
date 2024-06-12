ExUnit.start()

Mox.defmock(HTTPClientMock, for: HTTPoison.Base)
Application.put_env(:my_app, :api_handler, HTTPClientMock)
