require 'csv'

def blob(path)
  ActiveStorage::Blob.create_after_upload!(
    io: File.open(path),
    filename: SecureRandom.uuid,
    content_type: 'image/png'
  )
end

if ENV['CLEANUP'] == 'true'
  users = User.where(seed: true).to_a
  Comment.where(user: users).each { |comment| comment.destroy }
  Like.where(user: users).each { |comment| comment.destroy }
  Post.where(user: users).each { |post| post.destroy }
  users.each do |user|
    user.followers.each do |follower|
      follower.unfollow(user)
    end
    user.followees.each do |followee|
      user.unfollow(followee)
    end
  end
  return
end

post_captions = CSV.read(__dir__ + '/seeds/posts_captions.csv').transpose
user_captions = CSV.read(__dir__ + '/seeds/users_descriptions.csv').transpose
cities = CSV.read(__dir__ + '/seeds/cities.csv').flatten
comments = File.readlines(__dir__ + '/seeds/comments.txt').to_a.map(&:strip)

# Creating users and posts
user_captions.each_with_index do |(user_name, bio), index_user|
  profile_picture_path = __dir__ + "/seeds/users/#{index_user}/userpic.png"
  user = User.create!(user_name: user_name, bio: bio, profile_picture: blob(profile_picture_path), email: Faker::Internet.email, password: SecureRandom.alphanumeric(10), seed: true)
  post_captions[index_user].each_with_index do |caption, index_post|
    time = index_post.days.ago - rand(60 * 60 * 3).seconds
    post_path = __dir__ + "/seeds/users/#{index_user}/posts/images/image-#{index_post}.png"
    post = user.posts.create!(caption: caption, location: cities.sample, image: blob(post_path), created_at: time, updated_at: time)
  end
end

# Creating followers
followers = User.where(seed: true).first(5)
followers.each do |user|
  others = followers - [user]
  others.each do |other|
    user.follow(other)
    other.follow(user)
  end
end

# Existing users followship
seed_users = User.where(seed: true).to_a
User.where(seed: false).each do |user|
  seed_users.each do |seed_user|
    user.follow(seed_user)
    seed_user.follow(user)
  end
end

# Creating some likes
users = User.where(seed: true).to_a
Post.where(user: users).each do |post|
  likes_count = rand(users.size)
  next if likes_count.zero?

  shuffled_users = users.shuffle
  likes_count.times do |i|
    Like.create(user: shuffled_users[i], post: post)
  end
end

# Creating some comments
Post.where(user: users).each do |post|
  comments_count = rand(3)

  shuffled_users = users.shuffle
  comments_count.times do |i|
    Comment.create(user: shuffled_users[i], post: post, text: comments.sample)
  end
end
