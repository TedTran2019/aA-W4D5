class CommentsController < ApplicationController
	before_action :ensure_logged_in

	def create
		@comment = Comment.new(comment_params)
		@comment.user_id = current_user.id
		flash.now[:errors] = @comment.errors.full_messages unless @comment.save
		case @comment.commentable_type
		when 'Goal'
			redirect_to goal_url(@comment.commentable_id)
		when 'User'
			redirect_to user_url(@comment.commentable_id)
		end
	end

	private

	def comment_params
		params.require(:comment).permit(:body, :commentable_id, :commentable_type)
	end
end
