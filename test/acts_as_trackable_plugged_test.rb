require 'test_helper'

class ActsAsTrackablePlugged < ActiveSupport::TestCase
  def setup
    @user    = User.create(name: 'user')
    @post    = Post.create(title: 'post', modifier: @user)
    @comment = Comment.create(title: 'comment', modifier: @user)
  end

  def test_trackable_record_should_have_created_by
    assert_equal @post.created_by,    @user
    assert_equal @comment.created_by, @user
    assert_nil   @post.updated_by,    nil
    assert_nil   @comment.updated_by, nil
  end

  def test_trackable_record_should_have_updated_by
    @post.update(title: 'updated post', modifier: @user)
    @comment.update(title: 'updated comment', modifier: @user)
    assert_equal @post.created_by,    @user
    assert_equal @comment.created_by, @user
    assert_equal @post.updated_by,    @user
    assert_equal @comment.updated_by, @user
  end

  def test_trackable_record_should_have_object_activity
    assert_equal @post.object_activity,    Post.where(id: @post.id).left_joins_object_activities(['User']).first.object_activity
    assert_equal @comment.object_activity, Comment.where(id: @comment.id).left_joins_object_activities(['User']).first.object_activity
  end

  def test_left_joins_object_activities_should_raise_error_if_user_class_does_not_exist
    assert_raises(ActiveRecord::StatementInvalid, 'SQLite3::SQLException: no such table: RandUser') do
      Post.where(id: @post.id).left_joins_object_activities(['RandUser']).first
    end
  end

  def test_modifier_model_should_have_object_activities_creator
    @post.update(title: 'updated post', modifier: @user)
    assert_equal @user.object_activities_as_creator.first, ObjectActivity.find_by(created_by: @user)
    assert_equal @user.object_activities_as_updater.first, ObjectActivity.find_by(updated_by: @user)
  end

  def test_fallback_to_base_class_should_store_base_class_name_in_object_activity
    assert_equal @post.object_activity.object_type,    'Post'
    assert_equal @comment.object_activity.object_type, 'Post'
  end
end
