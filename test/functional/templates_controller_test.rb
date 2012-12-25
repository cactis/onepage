# -*- encoding : utf-8 -*-
require 'test_helper'

class TemplatesControllerTest < ActionController::TestCase
  setup do
    @template = templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create template" do
    assert_difference('Template.count') do
      post :create, :template => @template.attributes
    end

    assert_redirected_to template_path(assigns(:template))
  end

  test "should show template" do
    get :show, :id => @template.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @template.to_param
    assert_response :success
  end

  test "should update template" do
    put :update, :id => @template.to_param, :template => @template.attributes
    assert_redirected_to template_path(assigns(:template))
  end

  test "should destroy template" do
    assert_difference('Template.count', -1) do
      delete :destroy, :id => @template.to_param
    end

    assert_redirected_to templates_path
  end
end
