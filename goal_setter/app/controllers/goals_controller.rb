class GoalsController < ApplicationController
	before_action :ensure_logged_in

	def index
		@goals = current_user.goals
		render :index
	end

	def show
		@goal = Goal.find_by(id: params[:id])
		if @goal
			render :show
		else
			flash.now[:errors] = 'Not found!'
			render 'layouts/not_found', status: :not_found
		end
	end

	def new
		@goal = Goal.new
		render :new
	end

	def edit
		@goal = current_user.goals.find_by(id: params[:id])
		if @goal
			render :edit
		else
			flash.now[:errors] = 'Not found!'
			render 'layouts/not_found', status: :not_found
		end
	end

	def create
		@goal = Goal.new(goal_params)
		@goal.owner_id = current_user.id
		if @goal.save
			redirect_to goal_url(@goal)
		else
			flash.now[:errors] = @goal.errors.full_messages
			render :new
		end
	end

	def update
		@goal = current_user.goals.find_by(id: params[:id])
		if @goal
			if @goal.update_attributes(goal_params)
				redirect_to goals_url
			else
				flash.now[:errors] = @goal.errors.full_messages
				render :edit
			end
		else
			flash.now[:errors] = 'Not found!'
			render 'layouts/not_found', status: :not_found
		end
	end

	def destroy
		@goal = current_user.goals.find_by(id: params[:id])
		if @goal
			@goal.destroy
			redirect_to goals_url
		else
			flash.now[:errors] = 'Not found!'
			render 'layouts/not_found', status: :not_found
		end
	end

	private

	def goal_params
		params.require(:goal).permit(:title, :details, :private, :completed)
	end
end
