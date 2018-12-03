class UserController < ApplicationController
    before_action :authenticate
    def input
      @user = User.find(session[:user_id])
      user_channels = @user.channels_users

      @must_channel_ids = Array.new
      @good_channel_ids = Array.new
      @ok_channel_ids = Array.new
      user_channels.each do |uc|
          @must_channel_ids << Channel.find(uc.channel_id).id if uc.preferences == 'must'
          @good_channel_ids << Channel.find(uc.channel_id).id if uc.preferences == 'good'
          @ok_channel_ids << Channel.find(uc.channel_id).id if uc.preferences == 'ok'
      end
      @channels = Channel.all
      @recommendations = flash[:reco] || []
      @budget = session[:budget] || 100
    end

    def recommendation
      @user = User.find(session[:user_id])
      must_channel_ids = params[:must_channel_ids].map{ |id| id.split(",") }.flatten
      good_channel_ids = params[:good_channel_ids].map{ |id| id.split(",") }.flatten
      ok_channel_ids = params[:ok_channel_ids].map{ |id| id.split(",") }.flatten
      budget = params[:budget].empty? ? Float::INFINITY : params[:budget]
      if params[:budget]
        session[:budget] = params[:budget]
      end

      if !@user.nil? and !(must_channel_ids.empty? and good_channel_ids.empty? and ok_channel_ids.empty?)
          ChannelsUser.where(user_id: @user.id).delete_all
      end

      user_channels = []
      if !@user.nil?
        @user.add_channels(must_channel_ids, 'must')
        @user.add_channels(good_channel_ids, 'good')
        @user.add_channels(ok_channel_ids, 'ok')

        @user.save

        user_channels = @user.channels_users
      end


      flash[:reco] = User.recommendation(
        must_channel_ids,
        good_channel_ids,
        ok_channel_ids,
        StreamPackage.all,
        budget
      )
      redirect_to "/user/input"
    end
end
