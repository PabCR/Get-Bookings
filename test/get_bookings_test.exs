defmodule GetBookingsTest do
  use ExUnit.Case
  doctest GetBookings

  describe "fetch_data/1" do
    test "fetches data from valid url" do
      case GetBookings.fetch_data("https://dz4o5.wiremockapi.cloud/productmgmt/api/api/searchbooking") do
        {:ok, _} -> :ok
        _ -> assert false
      end
    end
    test "returns not_found from invalid url" do
      case GetBookings.fetch_data("https://dz4o5.wiremockapi.cloud//productmgmt/api/api/searchbooking") do
        {:not_found, _} -> :ok
        _ -> assert false
      end
    end
    test "returns error from invalid url" do
      case GetBookings.fetch_data("https://dz4o5.wiremockapis.cloud/productmgmt/api/api/searchbooking") do
        {:error, _} -> :ok
        _ -> assert false
      end
    end
  end
end
