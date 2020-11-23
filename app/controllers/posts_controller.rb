class PostsController < ApplicationController
  before_action :require_current_user, only: %i[create update like unlike save unsave tagged]

  def index
    @posts = Post.preload(:comments).order('id desc')
    render json: {
      data: @posts.map { |post| PostSerializer.new(post, self).serialize }
    }
  end

  def show
    @post = Post.find(params[:id])
    render json: {
      data: PostSerializer.new(@post, self).serialize
    }
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      update_tags
      render json: { data: PostSerializer.new(@post, self).serialize }
    else
      render_errors(@post.errors)
    end
  end

  def update
    @post = current_user.posts.find(params[:id])
    @post.attributes = post_params

    if @post.save
      update_tags
      render json: { data: PostSerializer.new(@post, self).serialize }
    else
      render_errors(@post.errors)
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

    render json: { data: PostSerializer.new(@post, self).serialize }
  end

  def like
    @like = Like.where(post_id: params[:id], user: current_user).take
    if @like.blank?
      Like.create!(post_id: params[:id], user: current_user)
      post = Post.find(params[:id])
      render json: { data: PostSerializer.new(post, self).serialize }
    else
      render json: { errors: [{ source: { parameter: 'id' }, detail: 'already liked' }] }, status: 409
    end
  end

  def unlike
    @like = Like.where(post_id: params[:id], user: current_user).take
    if @like.present?
      @like.destroy
      post = Post.find(params[:id])
      render json: { data: PostSerializer.new(post, self).serialize }
    else
      render json: { errors: [{ source: { parameter: 'id' }, detail: 'not found' }] }, status: 404
    end
  end

  def save
    @post_saved = PostSaved.where(post_id: params[:id], user: current_user).take
    if @post_saved.blank?
      PostSaved.create!(post_id: params[:id], user: current_user)
      post = Post.find(params[:id])
      render json: { data: PostSerializer.new(post, self).serialize }
    else
      render json: { errors: [{ source: { parameter: 'id' }, detail: 'already saved' }] }, status: 409
    end
  end

  def unsave
    @post_saved = PostSaved.where(post_id: params[:id], user: current_user).take
    if @post_saved.present?
      @post_saved.destroy
      post = Post.find(params[:id])
      render json: { data: PostSerializer.new(post, self).serialize }
    else
      render json: { errors: [{ source: { parameter: 'id' }, detail: 'not found' }] }, status: 404
    end
  end

  def saved
    @posts_saved = PostSaved.preload(:post).where(user: current_user).order('created_at desc')
    @posts = @posts_saved.map(&:post)
    render json: {
      data: @posts.map { |post| PostSerializer.new(post, self).serialize }
    }
  end

  def tagged
    @user = User.where(id: params[:user_id]).take || current_user
    @user_post_tags = UserPostTag.preload(post: :comments).where(user: @user)
    @posts = @user_post_tags.map(&:post)
    render json: {
      data: @posts.map { |post| PostSerializer.new(post, self).serialize }
    }
  end

  private

  def post_params
    result = params.require(:post).permit(:location, :image, :description)
    if result[:image].present?
      tempfile = Tempfile.new('image.jpg')
      tempfile.write(URI::Data.new(result[:image]).data.force_encoding('UTF-8'))
      tempfile.close
      result[:image] = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: SecureRandom.alphanumeric(10) + '.jpg')
    end
    result
  end

  def update_tags
    return if params[:post][:tags].blank?

    new_tags = params[:post][:tags].map do |tag|
      UserPostTag.create!(post: @post, user_id: tag[:user_id], top: tag[:top], left: tag[:left])
    end

    @post.user_post_tags = new_tags
  end
end
