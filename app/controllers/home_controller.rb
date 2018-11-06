class HomeController < ApplicationController
    before_action :authenticate
    def show
        @user = User.find(session[:user_id])
        # @channels = Channel.find_channels(session[:user_id])
        # @channels = User.channels
        if @channels.blank?
          flash[:notice] = "'#{@user}' has no saved preferences"
        end
    end
end