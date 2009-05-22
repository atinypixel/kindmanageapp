require File.dirname(__FILE__) + '/../test_helper'
require 'notes_controller'

# Re-raise errors caught by the controller.
class NotesController; def rescue_action(e) raise e end; end

class NotesControllerTest < Test::Unit::TestCase
  fixtures :notes

  def setup
    @controller = NotesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:notes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_notes
    old_count = Notes.count
    post :create, :notes => { }
    assert_equal old_count + 1, Notes.count

    assert_redirected_to notes_path(assigns(:notes))
  end

  def test_should_show_notes
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_notes
    put :update, :id => 1, :notes => { }
    assert_redirected_to notes_path(assigns(:notes))
  end

  def test_should_destroy_notes
    old_count = Notes.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Notes.count

    assert_redirected_to notes_path
  end
end
