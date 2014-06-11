class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase) #params come from form on signin page
		if user && user.authenticate(params[:session][:password])
			redirect_to user
		else
			flash.now[:error] = 'Invalid email/password'
			render 'new'
		end
	end

	def destroy
	end
end
