defmodule APIHandler do
  @moduledoc """
  Documentation for `APIHandler`.
  """
  import SweetXml
  def get_bookings(url_domain) do
    base_url = System.get_env("TEST_API_URL")
    url = "#{base_url}#{url_domain}"
    token = System.get_env("TEST_API_TOKEN")
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
  def get_bookings_new(_url_domain) do
    url = "https://bookitapiprod.seastreak.com/bookingservice.asmx"
    body = """
    <?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <SearchBookings xmlns="http://hfs.hogia.fi/webservices/">
            <searchParams>
              <FromChangedDate>2024-05-01T15:15:15.683</FromChangedDate>
            </searchParams>
          </SearchBookings>
        </soap:Body>
      </soap:Envelope>
    """
    username = "APIUser"
    password = "b3f99@@535"
    credentials_encoded = Base.encode64("#{username}:#{password}")
    # Authentication call
    {_message, %HTTPoison.Response{headers: array}} = authenticate()
    set_cookie1 = Enum.at(array, 4)
    |> IO.inspect()
    set_cookie2 = Enum.at(array, 5)
    |> IO.inspect()
    headers = [{"SOAPAction", "http://hfs.hogia.fi/webservices/SearchBookings"},
    {"Content-Type", "text/xml"}, {"Authorization", "Basic #{credentials_encoded}"}, set_cookie1, set_cookie2]
    HTTPoison.request(:post, url, body, headers)
  end



  def parse_xml(xml, key) do
    xml
    |> SweetXml.xmap(key: ~x"//#{key}/text()"l)
  end

  def authenticate() do
    username = "APIUser"
    password = "b3f99@@535"
    credentials_encoded = Base.encode64("#{username}:#{password}")

    url = "https://bookitapiprod.seastreak.com/userservice.asmx"
    headers = [{"SOAPAction", "http://hfs.hogia.fi/webservices/LoginUser"},
               {"Content-Type", "text/xml"}, {"Authorization", "Basic #{credentials_encoded}"}]
    # Authentication call
    # Basic AUTH (In the website)
    body = """
    <?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <LoginUser xmlns="http://hfs.hogia.fi/webservices/">
            <UserName>ProntoCX</UserName>
            <Password>ProntoCX</Password>
          </LoginUser>
        </soap:Body>
      </soap:Envelope>
    """
    HTTPoison.request(:post, url, body, headers)
    end
end
# User: APIUser
# Pass: b3f99@@535
