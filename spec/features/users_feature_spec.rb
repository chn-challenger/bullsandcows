require 'rails_helper'

feature "User can sign in and out" do
  context "user not signed in and on the homepage" do
    it "should see a 'sign in' link and a 'sign up' link" do
      visit('/')
      expect(page).to have_link('Login')
      expect(page).to have_link('Register')
    end

    it "should not see 'sign out' link" do
      visit('/')
      expect(page).not_to have_link('Sign out')
    end
  end

  context "user signed in on the homepage" do
    before do
      visit('/')
      click_link('Register')
      fill_in("Email...", with: 'test@example.com')
      fill_in('Username...', with: "testtest")
      fill_in('Password...', with: 'testtest')
      fill_in('Password confirmation...', with: 'testtest')
      click_button('Sign up')
    end

    it "should see 'sign out' link" do
      visit('/')
      expect(page).to have_link('Logout')
    end

    it "should not see a 'sign in' link and a 'sign up' link" do
      visit('/')
      expect(page).not_to have_link('Sign in')
      expect(page).not_to have_link('Register')
    end
  end
end

def sign_up user
  visit '/'
  click_link 'Register'
  fill_in 'Email...', with: user.email
  fill_in 'Username...', with: user.user_name
  fill_in 'Password...', with: user.password
  fill_in 'Password confirmation...', with: user.password_confirmation
  click_button 'Sign up'
end
