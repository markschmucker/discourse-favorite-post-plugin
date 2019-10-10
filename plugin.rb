# name: favorite-post
# about: Find Favorite Post
# authors: Mark Schmucker
# version: 0.1

after_initialize {
  class ::Jobs::FavoritePost
    def execute(args)
      SiteSetting.favorite_post = 12345
      
      user = User.find_by_username('JohnDoe')
      min_date = Time.now - (1 * 24 * 60 * 60)
      
      posts = Post
          .order("posts.like_count DESC")
          .for_mailing_list(user, min_date)
          .where('posts.post_type = ?', Post.types[:regular])
          .where('posts.deleted_at IS NULL AND posts.hidden = false AND posts.user_deleted = false')
          .where("posts.post_number > ?", 1)
          .where('posts.created_at < ?', (SiteSetting.editing_grace_period || 0).seconds.ago)
          .limit(10)
      
      max_like_count = posts.map(|post| post.like_count).max
      
      favorite_posts = nil
      if max_like_count > 4
        favorite_posts = posts.select(|post| post.like_count == max_like_count)
      end
      
      # todo: join them as a string? or easier, move this to the digest
      # plugin; no need to run separately.
      favorite_posts.each do |post|
        puts post
        SiteSetting.favorite_post = post.id
      end
    end
  end
}
