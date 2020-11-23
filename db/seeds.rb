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

post_descriptions = CSV.read(__dir__ + '/seeds/posts_descriptions.csv').transpose
user_descriptions = CSV.read(__dir__ + '/seeds/users_descriptions.csv').transpose
cities = CSV.read(__dir__ + '/seeds/cities.csv').flatten
comments = File.readlines(__dir__ + '/seeds/comments.txt').to_a.map(&:strip)

# Creating users and posts
user_descriptions.each_with_index do |(full_name, bio), index_user|
  portrait_path = __dir__ + "/seeds/users/#{index_user}/userpic.png"
  user = User.create!(full_name: full_name, bio: bio, portrait: blob(portrait_path), email: Faker::Internet.email, password: SecureRandom.alphanumeric(10), seed: true)
  post_descriptions[index_user].each_with_index do |description, index_post|
    time = index_post.days.ago - rand(60 * 60 * 3).seconds
    post_path = __dir__ + "/seeds/users/#{index_user}/posts/images/image-#{index_post}.png"
    post = user.posts.create!(description: description, location: cities.sample, image: blob(post_path), created_at: time, updated_at: time)
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
    Comment.create(user: shuffled_users[i], post: post, body: comments.sample)
  end
end
