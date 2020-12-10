Given('I am logged in as an activated user') do
  @user = FactoryBot.create(:user, activated: true, activated_at: Time.zone.now)

  visit login_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Log in'
end

Then(/^(?:|I )should see "([^"]*)"$/) do |text|
  expect(page).to have_content(text)
end

When ('I visit home page') do 
  visit root_path
end

When ('I visit following page') do 
  visit following_user_path(@user)
end

When ("I fill {string} into the {string} field") do |text, field|
  fill_in field, :with => text
end

And 'I click on element {string}' do |selector|
  find(selector).click
end

Then(/^(?:|I )should not see "([^"]*)"$/) do |text|
  expect(page).to have_no_content(text)
end

When /^I click on the "([^"]*)" link$/ do |link|
  click_link link
end

