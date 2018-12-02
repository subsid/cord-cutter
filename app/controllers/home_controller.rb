class HomeController < ApplicationController
    before_action :authenticate
    def show
        @user = User.find(session[:user_id])

        if params[:must_channels] || params[:good_channels] ||params[:okay_channels]
            ChannelsUser.where(user_id: @user.id).delete_all
        end

        @user.add_channels(params[:must_channels], 'must')
        @user.add_channels(params[:good_channels], 'good')
        @user.add_channels(params[:okay_channels], 'ok')

        @user.save

        user_channels = @user.channels_users
        # if user_channels.blank?
        #   flash[:notice] = "'#{@user}' has no saved preferences"
        # end

        @all_channels = Array.new
        Channel.all.each do |c|
            @all_channels << c.name
        end

        @must_channels = Array.new
        @good_channels = Array.new
        @okay_channels = Array.new
        user_channels.each do |uc|
            @must_channels << Channel.find(uc.channel_id).name if uc.preferences == 'must'
            @good_channels << Channel.find(uc.channel_id).name if uc.preferences == 'good'
            @okay_channels << Channel.find(uc.channel_id).name if uc.preferences == 'ok'
        end
    end

end
