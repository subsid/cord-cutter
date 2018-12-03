Given(/^the following packages exist:$/) do |packages_table|
  packages_table.hashes.each do |package_hash|
    StreamPackage.create package_hash
  end
end

Given(/^the following channels exist:$/) do |channels_table|
  channels_table.hashes.each do |channel_hash|
    Channel.create channel_hash
  end
end

Then("the cost of {string} should be {int}") do |package_name, cost|
  package = StreamPackage.find_by(name: package_name)
  expect(cost).to eq(package.cost)
end

Then("the category of {string} should be {string}") do |channel_name, category|
  channel = Channel.find_by(name: channel_name)
  expect(category).to eq(channel.category)
end

Then(/^I go with "([^"]*)" from Channels$/) do |channel|
  first('input#channel_dropdown', visible:false).set(Channel.find_by(name: channel).id)
end