require 'rails_helper'

feature 'the signup process' do
	scenario 'has a new user page' do
		visit new_user_url
		expect(page).to have_content "Sign Up!"
	end

  feature 'signing up a user' do
		scenario 'shows username on the homepage after signup' do
			visit new_user_url
			fill_in 'username', with: 'test'
			fill_in 'password', with: 'valid-password'
			click_button 'Sign Up'
			expect(page).to have_content 'Welcome test'
		end
  end
end

feature 'logging in' do
	scenario 'shows username on the homepage after login' do
		sign_up('test', 'valid-password')
		click_on 'Log Out'
		visit new_session_url
		fill_in 'username', with: 'test'
		fill_in 'password', with: 'valid-password'
		click_button 'Log In'
		expect(page).to have_content 'Welcome test'
	end
end

feature 'logging out' do
	scenario 'begins with a logged out state' do
		visit users_url
		expect(page).to have_content 'Log In'
	end

	scenario 'doesn\'t show username on the homepage after logout' do
		sign_up('test', 'valid-password')
		visit users_url
		expect(page).to have_content 'Welcome test'
		click_on 'Log Out'
		visit users_url
		expect(page).to_not have_content 'Welcome test'
	end
end
