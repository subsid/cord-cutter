# home_controller_spec.rb
require 'spec_helper'
 
describe HomeController, :type => :controller do 
 
 describe "#open" do
     it "should redirect to signin page" do
         get :show
         expect(response).to have_http_status(302)
         response.should redirect_to '/signin'
     end
     
     it "should open home page" do
         user = User.create(first_name: "fofo", email: "fofo@gmail.com")
         channels = []
         ["hbo", "star", "abc", "news"].each do |channel_name|
             channels << Channel.create(name: channel_name).id
         end
         input_params = {
             :must_channels => [channels[0], channels[1]],
             :good_channels => [channels[2]],
             :okay_channels => [channels[3]]
         }
         get :show, params: input_params, session: {:user_id => user.id}
         expect(response).to have_http_status(200)
     end
 end
 
end