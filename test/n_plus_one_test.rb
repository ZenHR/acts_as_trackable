require 'test_helper'

# Test to validate N+1 query issues when accessing created_by/updated_by after eager loading
class NPlusOneTest < ActiveSupport::TestCase
  def setup
    # Clean up any existing data to ensure isolation
    ObjectActivity.delete_all
    Post.delete_all
    User.delete_all

    @users = 3.times.map { |i| User.create(name: "user_#{i}") }
    @posts = @users.map.with_index { |user, i| Post.create(title: "post_#{i}", modifier: user) }

    # Update posts with different users
    @posts.each_with_index do |post, i|
      next_user = @users[(i + 1) % @users.length]
      post.update(title: "updated_post_#{i}", modifier: next_user)
    end
  end

  def test_n_plus_one_without_proper_preload
    # Load posts with only object_activity included
    posts = Post.includes(:object_activity).all

    # Track queries when accessing created_by
    queries_count = count_queries do
      posts.each do |post|
        post.created_by.name  # This should cause N+1 if created_by is not preloaded
      end
    end

    # With N+1, we expect: 1 (posts) + 1 (object_activities) + N (created_by users)
    # So for 3 posts, we'd get 5 queries (1 + 1 + 3)
    puts "Queries without nested preload (created_by): #{queries_count}"
    assert queries_count > 3, "Expected N+1 queries when accessing created_by without nested preload"
  end

  def test_n_plus_one_fixed_with_nested_preload
    # Load posts with nested preload including created_by and updated_by
    posts = Post.includes(object_activity: [:created_by, :updated_by]).all

    # Track queries when accessing created_by and updated_by
    queries_count = count_queries do
      posts.each do |post|
        post.created_by.name
        post.updated_by&.name
      end
    end

    # With proper preload, we expect: 1 (posts) + 1 (object_activities) + 1 (users for created_by) + 1 (users for updated_by)
    # So ideally 4 queries total, but no N+1
    puts "Queries with nested preload: #{queries_count}"
    assert queries_count <= 4, "Expected no N+1 queries when using nested preload, got #{queries_count}"
  end

  def test_accessing_created_by_attributes_after_eager_load
    # This tests the real-world usage pattern
    # IMPORTANT: Load the data first, THEN count queries when accessing attributes
    posts = Post.includes(object_activity: [:created_by, :updated_by]).to_a

    results = nil
    queries_count = count_queries do
      results = posts.map do |post|
        {
          title: post.title,
          created_by_name: post.created_by&.name,
          updated_by_name: post.updated_by&.name,
          updated_at: post.object_activity&.updated_at
        }
      end
    end

    puts "Queries for real-world usage pattern: #{queries_count}"

    # Run assertions outside query counting
    assert_equal 3, results.length
    results.each do |result|
      assert_not_nil result[:created_by_name]
      assert_not_nil result[:updated_by_name]
    end

    assert queries_count == 0, "Expected 0 queries after eager loading, got #{queries_count}"
  end

  def test_preloader_style_loading
    # Test using ActiveRecord::Associations::Preloader
    posts = Post.all.to_a

    ActiveRecord::Associations::Preloader.new(
      records: posts,
      associations: { object_activity: %i[created_by updated_by] }
    ).call

    queries_count = count_queries do
      posts.each do |post|
        post.created_by.name
        post.updated_by&.name
      end
    end

    puts "Queries after Preloader.call: #{queries_count}"
    assert queries_count == 0, "Expected 0 queries after Preloader.call, got #{queries_count}"
  end

  def test_left_joins_object_activities_with_select
    # Test the left_joins_object_activities scope usage
    # Load the data first to separate the initial query from subsequent accesses
    posts = Post.left_joins_object_activities(['User'])
                .select('posts.*,
                        created_by_users.name as created_by_name,
                        updated_by_users.name as updated_by_name').to_a

    queries_count = count_queries do
      posts.each do |post|
        # Access the selected attributes
        post.attributes['created_by_name']
        post.attributes['updated_by_name']
      end
    end

    puts "Queries with left_joins_object_activities and select: #{queries_count}"
    # Should be 0 since everything is in one query and already loaded
    assert queries_count == 0, "Expected 0 additional queries with left_joins, got #{queries_count}"
  end

  private

  def count_queries(&block)
    queries = []

    query_counter = lambda do |_name, _start, _finish, _id, payload|
      unless payload[:name] == 'SCHEMA' || payload[:sql] =~ /^(BEGIN|COMMIT|ROLLBACK)/
        queries << payload[:sql]
      end
    end

    ActiveSupport::Notifications.subscribed(query_counter, 'sql.active_record') do
      block.call
    end

    queries.length
  end
end
