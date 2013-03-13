FactoryGirl.define do
  sequence(:email) {|n| "user#{n}@domain.com" }
  factory :user do
    first_name 'Joe'
    last_name 'Schmoe'

    password "123456"
    password_confirmation "123456"

    factory :confirmed_user do
      confirmed_at { Time.now }
      email { generate :email }
      after(:create) do |u|
        u.skip_reconfirmation!
        u.email = u.unconfirmed_email
        u.unconfirmed_email = nil
        u.save!
      end
    end
  end
end