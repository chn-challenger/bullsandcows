FactoryGirl.define do
  factory :user do
    email 'testing@testing.com'
    user_name 'testing'
    password 'testtest'
    password_confirmation 'testtest'
  end
end
