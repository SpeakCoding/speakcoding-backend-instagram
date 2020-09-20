class PostsController < ApplicationController
  def index
    posts = Post.order("id desc")
    render json: { data: posts.map{|post| serialize_post(post) }}
  end

  def create
    post = Post.new(post_params)
    post.user = current_user
    if current_user.blank?
      render json: { errors: [{source: { parameter: "user_id" }, detail: "not authorized"}] }, status: 403
    elsif !post.save
      render_errors(post.errors)
    else
      render json: { data: serialize_post(post) }
    end
  end

  private

  def post_params
    params.require(:post).permit(:location, :image, :description)
  end

  def serialize_post(post)
    { 
      id: post.id, 
      location: post.location,
      description: post.description,
      image: url_for(post.image.variant(resize_to_limit: [1080, 1080])),
      user: {id: post.user.id, email: post.user.email},
      created_at: post.created_at.to_i
    }
  end
end
