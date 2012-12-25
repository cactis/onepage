# -*- encoding : utf-8 -*-
require 'test_helper'

class ScratchesControllerTest < ActionController::TestCase
  setup do
    @scratch = scratches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scratches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scratch" do
    assert_difference('Scratch.count') do
      post :create, :scratch => @scratch.attributes
    end

    assert_redirected_to scratch_path(assigns(:scratch))
  end

  test "should show scratch" do
    get :show, :id => @scratch.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @scratch.to_param
    assert_response :success
  end

  test "should update scratch" do
    put :update, :id => @scratch.to_param, :scratch => @scratch.attributes
    assert_redirected_to scratch_path(assigns(:scratch))
  end

  test "should destroy scratch" do
    assert_difference('Scratch.count', -1) do
      delete :destroy, :id => @scratch.to_param
    end

    assert_redirected_to scratches_path
  end
end
