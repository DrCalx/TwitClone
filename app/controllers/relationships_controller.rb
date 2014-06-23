class RelationshipsController < ApplicationController
	before_action :signed_in_user
	def create
		#relationship = params[:relationship]
		#@user = User.find(relationship[:followed_id])
		#current_user.follow!(@user)
		#edirect_to @user
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		redirect_to @user
	end
end