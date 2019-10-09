# name: favorite-post
# about: Find Favorite Post
# authors: Mark Schmucker
# version: 0.1

after_initialize {
  class ::Jobs::FavoritePost
    def execute(args)
      SiteSetting.favorite_post = 12345
    end
  end
}

