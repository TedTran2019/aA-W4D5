class UsersController < ApplicationController
	def index
		@users = User.all
		render :index
	end

	def new
		@user = User.new
		render :new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			login!(@user)
			redirect_to user_url(@user)
		else
			flash.now[:errors] = @user.errors.full_messages
			render :new
		end
	end

	def show
		@user = User.find_by(id: params[:id])
		if @user
			render :show
		else
			flash.now[:errors] = "User not found!"
			render 'layouts/not_found', status: :not_found
		end
	end

	private

	def user_params
		params.require(:user).permit(:username, :password)
	end
end