require 'rails_helper'

feature 'starting a new game' do
  before do
    $invites = Hash.new
  end

  context 'visiting homepage; signed out' do
    scenario 'displays a "Enter game"' do
      visit '/'
      expect(page).to have_link 'Enter game'
    end
  end

  context 'clicking "Enter game" link on homepage' do
    scenario 'can challenge a user' do
      user = build :user
      user2 = build :user, email: 'testing@testing.com', user_name: 'testing2'
      sign_up user
      click_link 'Enter game'
      expect(current_path).to eq '/games/index'
      fill_in 'challengee', with: user2.user_name
      click_button 'Send challenge'
    end

    scenario 'can accept a challenge' do
      user = build :user
      user2 = build :user, email: 'testing@testing.com', user_name: 'testing2'
      sign_up user
      $invites[user.user_name] = user2.user_name
      click_link 'Enter game'
      expect(page).to have_content "#{user2.user_name} has challenged you to play a game. Would you accept?"
      expect(page).to have_button 'Accept challenge'
      click_button 'Accept challenge'
      expect(current_path).to eq '/games/secret'
    end
  end
end

feature 'playing a game' do
  context 'clicking "Start game" link on index page' do
    xscenario 'can set a secret key' do
      user = build :user
      sign_up user
      click_link 'Enter game'
      click_link 'Start game'
      fill_in 'Key', with: '1357'
      click_button 'Enter secret key'
      expect(page).to have_button 'Submit guess'
      expect(current_path).to eq '/games/new'
    end
  end
end
