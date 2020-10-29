class PostsController < ApplicationController
  def index
    posts = Post.order('id desc')
    render json: {
      data: posts.map { |post| PostSerializer.new(post, self).serialize }
    }
  end

  def show
    post = Post.find(params[:id])
    render json: {
      data: PostSerializer.new(post, self).serialize
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

  def like
    like = Like.where(post_id: params[:id], user: current_user).take
    if like.blank?
      Like.create!(post_id: params[:id], user: current_user)
      post = Post.find(params[:id])
      render json: { data: PostSerializer.new(post, self).serialize }
    else
      render json: { errors: [{ source: { parameter: 'id' }, detail: 'already liked'}] }, status: 409
    end
  end

  def unlike
    like = Like.where(post_id: params[:id], user: current_user).take
    if like.present?
      like.destroy
      post = Post.find(params[:id])
      render json: { data: PostSerializer.new(post, self).serialize }
    else
      render json: { errors: [{ source: { parameter: 'id' }, detail: 'not found'}] }, status: 404
    end
  end

  private

  def post_params
    result = params.require(:post).permit(:location, :image, :description)
    if result[:image].present?
      tempfile = Tempfile.new("image.jpg")
      tempfile.write(URI::Data.new(result[:image]).data.force_encoding('UTF-8'))
      tempfile.close
      result[:image] = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: SecureRandom.alphanumeric(10) + ".jpg")
    end
    result
  end
end
