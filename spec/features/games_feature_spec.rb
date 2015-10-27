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
      sign_up user
      click_link 'Enter game'
      expect(current_path).to eq '/games/index'
      user2 = create :user, email: 'testing2@testing.com', user_name: 'testing2'
      fill_in 'challengee', with: user2.user_name
      click_button 'Send challenge'
    end

    scenario 'can accept a challenge' do
      user = build :user
      sign_up user
      $invites[user.user_name] = 'testing2'
      click_link 'Enter game'
      expect(page).to have_content "testing2 has challenged you to play a game. Would you accept?"
      expect(page).to have_button 'Accept challenge'
      click_button 'Accept challenge'
      expect(current_path).to eq '/games/set_secret'
    end
  end
end

feature 'playing a game' do
  context 'inputting secret key on secret page' do
    scenario 'can set a secret key' do
      user = build :user
      sign_up user
      $invites[user.user_name] = 'testing2'
      click_link 'Enter game'
      expect(page).to have_content "testing2 has challenged you to play a game. Would you accept?"
      expect(page).to have_button 'Accept challenge'
      click_button 'Accept challenge'
      fill_in 'key', with: '1357'
      click_button 'Enter secret key'
      expect(page).to have_field 'guess'
      expect(page).to have_button 'Submit guess'
      expect(current_path).to eq '/games/new'
    end
  end

  context 'submitting guess on index page' do
    scenario 'can submit guess' do
      user = build :user
      sign_up user
      $invites[user.user_name] = 'testing2'
      click_link 'Enter game'
      expect(page).to have_content "testing2 has challenged you to play a game. Would you accept?"
      expect(page).to have_button 'Accept challenge'
      click_button 'Accept challenge'
      fill_in 'key', with: '1357'
      click_button 'Enter secret key'
      fill_in 'guess', with: '1357'
      click_button 'Submit guess'
      expect(page).to have_content '1357'
    end
  end
end
