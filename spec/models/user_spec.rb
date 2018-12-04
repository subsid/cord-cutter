require 'rails_helper'

RSpec.describe User, :type => :model do
  # subject { described_class.new(password: "some_password", email: "john@doe.com") }

  
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    # it "is not valid without a email" do
    #   subject.email = nil
    #   expect(subject).to_not be_valid
    # end

    it "is not valid without an picture" do
      subject.picture = nil
      expect(subject).to be_valid
    end
  # end
  
  
end