class CommentsController < ApplicationController
  before_action :require_current_user, only: %i[create update destroy]

  def create()
    attributes = params.require(:comment).permit(:post_id, :text, :reply_id)
    @comment = Comment.new(attributes)
    @comment.user = current_user

    if @comment.save()
      render(json: { data: CommentSerializer.new(@comment, self).serialize() })
    else
      render_errors(@comment.errors)
    end
  end

  def update()
    @comment = Comment.find(params[:id])

    attributes = params.require(:comment).permit(:text)

    @comment.attributes = attributes

    if @comment.save()
      render(json: { data: CommentSerializer.new(@comment, self).serialize })
    else
      render_errors(@comment.errors)
    end
  end

  def destroy()
    @comment = Comment.find(params[:id])
    @comment.destroy()

    render(json: { data: CommentSerializer.new(@comment, self).serialize })
  end
end
