require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Stats.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Stats.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Stats.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to stats_url(assigns(:stats))
  end

  def test_edit
    get :edit, :id => Stats.first
    assert_template 'edit'
  end

  def test_update_invalid
    Stats.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Stats.first
    assert_template 'edit'
  end

  def test_update_valid
    Stats.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Stats.first
    assert_redirected_to stats_url(assigns(:stats))
  end

  def test_destroy
    stats = Stats.first
    delete :destroy, :id => stats
    assert_redirected_to stats_url
    assert !Stats.exists?(stats.id)
  end
end
