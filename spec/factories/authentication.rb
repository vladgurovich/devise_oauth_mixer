FactoryGirl.define do
  factory :authentication do
    association :user
    provider "facebook"
    username "username"
    email "email@domain.com"
    uid "12345"
    authentication_token "abc123"
    secondary_token nil
    token_expires_at nil
  end
end