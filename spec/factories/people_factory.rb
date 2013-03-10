FactoryGirl.define do
  factory :person do
    first_name Forgery::Name.first_name
    last_name Forgery::Name.last_name
  end

end
