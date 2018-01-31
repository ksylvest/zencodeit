require 'test_helper'

class MainControllerTest < ActionController::TestCase

  test 'should get about' do
    get :about
    assert_response :success
  end

  test 'should get terms' do
    get :terms
    assert_response :success
  end

end
