require 'rails_helper'

describe User, type: :model do

  it 'username is not valid with less than 4 characters' do
    user = User.new(user_name: "ben")
    expect(user).to have(1).error_on(:user_name)
    expect(user).not_to be_valid
  end

  it 'username is not valid with less more than 16 characters' do
    user = User.new(user_name: "adrianfintanbooth1707")
    expect(user).to have(1).error_on(:user_name)
    expect(user).not_to be_valid
  end

end
