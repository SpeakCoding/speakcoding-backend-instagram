class PostsController < ApplicationController
  def index
    posts = Post.order('id desc')
    render json: {
      data: posts.map { |post| PostSerializer.new(post, self).serialize }
    }
  end

  def create
    post = Post.new(post_params)
    post.user = current_user
    if current_user.blank?
      render json: { errors: [{ source: { parameter: 'user_id' }, detail: 'not authorized'}] }, status: 403
    elsif !post.save
      render_errors(post.errors)
    else
      render json: { data: PostSerializer.new(post, self).serialize }
    end
  end

  private

  def post_params
    params.require(:post).permit(:location, :image, :description)
  end
end
