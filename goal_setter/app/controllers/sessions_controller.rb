class SessionsController < ApplicationController
	def new
		@user = User.new
		render :new
	end

	def create
		@user = User.new(user_params)
		@real_user = User.find_by_credentials(user_params[:username], user_params[:password])
		if @real_user
			login!(@real_user)
			redirect_to user_url(@real_user)
		else
			flash.now[:errors] = "Incorrect credentials!"
			render :new
		end
	end

	def destroy
		logout! if logged_in?
		redirect_to new_session_url
	end

	private

	def user_params
		params.require(:user).permit(:username, :password)
	end
end
