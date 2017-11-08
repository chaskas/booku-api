require 'test_helper'

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client = clients(:one)
  end

  test "should get index" do
    get clients_url, as: :json
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post clients_url, params: { client: { address: @client.address, car_brand: @client.car_brand, car_color: @client.car_color, car_license: @client.car_license, car_model: @client.car_model, city: @client.city, email: @client.email, first_name: @client.first_name, last_name: @client.last_name, phone: @client.phone, rut: @client.rut } }, as: :json
    end

    assert_response 201
  end

  test "should show client" do
    get client_url(@client), as: :json
    assert_response :success
  end

  test "should update client" do
    patch client_url(@client), params: { client: { address: @client.address, car_brand: @client.car_brand, car_color: @client.car_color, car_license: @client.car_license, car_model: @client.car_model, city: @client.city, email: @client.email, first_name: @client.first_name, last_name: @client.last_name, phone: @client.phone, rut: @client.rut } }, as: :json
    assert_response 200
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete client_url(@client), as: :json
    end

    assert_response 204
  end
end
