require 'test_helper'

class StreamPackagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stream_package = stream_packages(:one)
  end

  test "should get index" do
    get stream_packages_url
    assert_response :success
  end

  test "should get new" do
    get new_stream_package_url
    assert_response :success
  end

  test "should create stream_package" do
    assert_difference('StreamPackage.count') do
      post stream_packages_url, params: { stream_package: { cost: @stream_package.cost, name: @stream_package.name } }
    end

    assert_redirected_to stream_package_url(StreamPackage.last)
  end

  test "should show stream_package" do
    get stream_package_url(@stream_package)
    assert_response :success
  end

  test "should get edit" do
    get edit_stream_package_url(@stream_package)
    assert_response :success
  end

  test "should update stream_package" do
    patch stream_package_url(@stream_package), params: { stream_package: { cost: @stream_package.cost, name: @stream_package.name } }
    assert_redirected_to stream_package_url(@stream_package)
  end

  test "should destroy stream_package" do
    assert_difference('StreamPackage.count', -1) do
      delete stream_package_url(@stream_package)
    end

    assert_redirected_to stream_packages_url
  end
end
