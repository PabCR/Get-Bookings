defmodule APIHandlerTest do
  use ExUnit.Case
  import Mox
  doctest APIHandler

  @http_client HTTPClientMock
  @test_config http_client: @http_client, url: System.get_env("TEST_API_URL"), method: :post
  @success_resp %{
    "Bookings" => [
      %{
        "AgentNumber" => "string",
        "ArrivalDate" => "2019-08-24T14:15:22Z",
        "BookingNumber" => 0,
        "BookingStatus" => "string",
        "BookingVersion" => 0,
        "ChangeTimeStamp" => "2019-08-24T14:15:22Z",
        "ChangedByInitials" => "string",
        "CreateTimeStamp" => "2019-08-24T14:15:22Z",
        "CreatorInitials" => "string",
        "CurrencyCode" => "string",
        "CustomerNumber" => "string",
        "DepartureDate" => "2019-08-24T14:15:22Z",
        "Email" => "string",
        "ExternalBookingNumber" => "string",
        "InternalReference" => "string",
        "Name" => "string",
        "PaymentMethod" => "string",
        "PaymentStatus" => 1,
        "PaymentType" => "string",
        "PoNumber" => "string",
        "ProductCode" => "string",
        "ProjectCode" => "string",
        "Type" => "string"
      }
    ],
    "TotalBookingsFound" => 1
  }
  @not_found_resp "Not found"
  @error_resp "something went wrong"

  describe "get_bookings/1" do
    test "returns {:ok, _} from valid url" do
      expect(@http_client, :request, fn :post,
                                        "https://dz4o5.wiremockapi.cloud/productmgmt/api/api/searchbooking",
                                        "",
                                        [
                                          {"Authorization",
                                           "Bearer 9e3011c7-e012-4f42-94af-9ed6234d3dd6"}
                                        ] ->
        {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
      end)

      assert {:ok, @success_resp} ==
               APIHandler.get_bookings("/productmgmt/api/api/searchbooking", @test_config)
    end

    test "returns not_found from invalid url" do
      expect(@http_client, :request, fn :post,
                                        "https://dz4o5.wiremockapi.cloud/xproductmgmt/api/api/searchbooking",
                                        "",
                                        [
                                          {"Authorization",
                                           "Bearer 9e3011c7-e012-4f42-94af-9ed6234d3dd6"}
                                        ] ->
        {:not_found,
         %HTTPoison.Response{body: @not_found_resp |> Jason.encode!(), status_code: 404}}
      end)

      assert {:not_found, @not_found_resp} ==
               APIHandler.get_bookings("/xproductmgmt/api/api/searchbooking", @test_config)
    end

    test "returns error from invalid url" do
      expect(@http_client, :request, fn :post,
                                        "https://dz4o5.wiremockapi.cloudx/productmgmt/api/api/searchbooking",
                                        "",
                                        [
                                          {"Authorization",
                                           "Bearer 9e3011c7-e012-4f42-94af-9ed6234d3dd6"}
                                        ] ->
        {:error, "something went wrong"}
      end)

      assert {:error, @error_resp} ==
               APIHandler.get_bookings("x/productmgmt/api/api/searchbooking", @test_config)
    end
  end
end
