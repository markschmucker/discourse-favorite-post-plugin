# name: favorite-post
# about: Find Favorite Post
# authors: Mark Schmucker
# version: 0.1

after_initialize {
  class ::Jobs::FavoritePost
    def execute(args)
      SiteSetting.favorite_post = 12345
      
      user = User.find_by_username('JohnDoe')
      min_date = Time.now - (5 * 24 * 60 * 60)
      
      favorite_posts = Post
          .order("posts.score DESC")
          .for_mailing_list(user, min_date)
          .where('posts.post_type = ?', Post.types[:regular])
          .where('posts.deleted_at IS NULL AND posts.hidden = false AND posts.user_deleted = false')
          .where("posts.post_number > ?", 1)
          .where('posts.created_at < ?', (SiteSetting.editing_grace_period || 0).seconds.ago)
          .limit(5)
      favorite_posts.each do |post|
        puts post
      end
    end
  end
}
