# signin_controller_spec.rb
require 'spec_helper'
 
describe SigninController, :type => :controller do 
 
 describe "#open" do
     it "should open signin page" do
         get :show
         expect(response).to have_http_status(200)
     end
 end
 
end
 