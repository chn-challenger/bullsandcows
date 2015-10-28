require 'rails_helper'

feature 'starting a new game' do
  before do
    $users = Array.new
    $invites = Hash.new
    $game = nil
  end

  context 'visiting homepage; signed out' do
    scenario 'displays a "Enter game"' do
      visit '/'
      expect(page).to have_link 'Enter game'
    end
  end

  context 'entering game from homepage' do
    scenario 'user must be signed in to enter game' do
      visit '/'
      click_link 'Enter game'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(current_path).to eq '/users/sign_in'
    end

    scenario 'can see a list of other users currently online on index page' do
      user = build :user
      user2 = create :user, email: 'testing2@testing.com', user_name: 'testing2'
      $users << user2.user_name
      sign_up user
      click_link 'Enter game'
      expect(page).to have_content user2.user_name
      expect(current_path).to eq '/games/index'
    end

    scenario 'can challenge a user on index page' do
      user = build :user
      sign_up user
      click_link 'Enter game'
      user2 = create :user, email: 'testing2@testing.com', user_name: 'testing2'
      fill_in 'challengee', with: user2.user_name
      click_button 'Send challenge'
    end

    scenario 'can accept a challenge on index page' do
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
  before do
    $users = Array.new
    $invites = Hash.new
    $game = nil
  end

  context 'inputting secret key on secret page' do
    scenario 'can set a secret key' do
      user = build :user
      sign_up user
      $invites[user.user_name] = 'testing2'
      click_link 'Enter game'
      click_button 'Accept challenge'
      fill_in 'key', with: '1357'
      click_button 'Enter secret key'
      expect(page).to have_content "#{user.user_name}'s move"
      expect(page).to have_content "testing2's move"
      expect(current_path).to eq '/games/new'
    end
  end

  context 'submitting guess on index page' do
    xscenario 'can submit guess' do
      user = build :user
      sign_up user
      $invites['testing2'] = user.user_name
      click_link 'Enter game'
      fill_in 'key', with: '1357'
      click_button 'Enter secret key'
      fill_in 'guess', with: '1357'
      click_button 'Submit guess'
      expect(page).to have_content '1357'
    end
  end
end
