Given ('I followed a user who has microposts') do 
  @user = FactoryBot.create(:user, activated: true, activated_at: Time.zone.now)
  visit login_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Log in'
end

When(/^I go to the list of users$/) do
  visit users_path
end

Then ('I should see my name') do 
  expect(page).to have_content(@user.name)
end


