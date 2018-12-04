require 'rails_helper'

RSpec.describe Channel, :type => :model do
   subject { described_class.new() }

    it "is valid with valid attributes" do
      expect(Channel.new).to be_valid
    end
    
    it "is valid with valid attributes" do
    subject.name = "ESPN"
    subject.category = "MUST"
    expect(subject).to be_valid
  end
    
    # it "is not valid without a name" do
    #   subject.name = nil
    #   expect(subject).to_not be_valid
    # end

    # it "is not valid without an category" do
    #   subject.category = nil
    #   expect(subject).to_not be_valid
    # end
end