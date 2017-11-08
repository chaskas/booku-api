require 'test_helper'

class PtypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ptype = ptypes(:one)
  end

  test "should get index" do
    get ptypes_url, as: :json
    assert_response :success
  end

  test "should create ptype" do
    assert_difference('Ptype.count') do
      post ptypes_url, params: { ptype: { name: @ptype.name } }, as: :json
    end

    assert_response 201
  end

  test "should show ptype" do
    get ptype_url(@ptype), as: :json
    assert_response :success
  end

  test "should update ptype" do
    patch ptype_url(@ptype), params: { ptype: { name: @ptype.name } }, as: :json
    assert_response 200
  end

  test "should destroy ptype" do
    assert_difference('Ptype.count', -1) do
      delete ptype_url(@ptype), as: :json
    end

    assert_response 204
  end
end
