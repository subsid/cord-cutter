# user_controller_spec.rb
require 'spec_helper'
 
describe UserController, :type => :controller do
    before do
        @user = User.create(first_name: "fofo", email: "fofo@gmail.com")
        @channels = []
        ["hbo", "star", "abc", "news"].each do |channel_name|
         @channels << Channel.create(name: channel_name).id
        end
    end
    
    describe "#redirect" do
        it "should redirect to signin page" do
            get :input
            expect(response).to have_http_status(302)
            response.should redirect_to '/signin'
        end
    end
    
    describe "#input" do
        it "should open user input" do
            get :input, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
        
        it "should open user input with previous history" do
            @user.add_channels([@channels[0], @channels[1]], 'must')
            @user.add_channels([@channels[2]], 'good')
            @user.add_channels([@channels[3]], 'ok')
            @user.save()
            
            get :input, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
    end
    
    describe "#recomendation" do
        it "should redirect to user input page after get recommendation" do
            input_params = {
             :must_channel_ids => [@channels[0], @channels[1]],
             :good_channel_ids => [@channels[2]],
             :ok_channel_ids => [@channels[3]],
             :budget => 100
            }
            post :recommendation, params: input_params, session: {:user_id => @user.id}
            response.should redirect_to '/user/input'
        end
    end
end