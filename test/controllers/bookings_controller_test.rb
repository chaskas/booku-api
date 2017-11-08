require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = bookings(:one)
  end

  test "should get index" do
    get bookings_url, as: :json
    assert_response :success
  end

  test "should create booking" do
    assert_difference('Booking.count') do
      post bookings_url, params: { booking: { adults: @booking.adults, arrival: @booking.arrival, childrens: @booking.childrens, client_id_id: @booking.client_id_id, departure: @booking.departure, discount: @booking.discount, place_id_id: @booking.place_id_id, price: @booking.price, status: @booking.status } }, as: :json
    end

    assert_response 201
  end

  test "should show booking" do
    get booking_url(@booking), as: :json
    assert_response :success
  end

  test "should update booking" do
    patch booking_url(@booking), params: { booking: { adults: @booking.adults, arrival: @booking.arrival, childrens: @booking.childrens, client_id_id: @booking.client_id_id, departure: @booking.departure, discount: @booking.discount, place_id_id: @booking.place_id_id, price: @booking.price, status: @booking.status } }, as: :json
    assert_response 200
  end

  test "should destroy booking" do
    assert_difference('Booking.count', -1) do
      delete booking_url(@booking), as: :json
    end

    assert_response 204
  end
end
