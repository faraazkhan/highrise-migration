FactoryGirl.define do
  factory :transfer do
    source_url "https://sevarapartners.highrisehq.com/"
    target_url 'http://rationalizeitllc.highrisehq.com'
    source_api_token 'cf40826f62c4c5e2d795db9bd7110523'
    target_api_token '6789123'
  end

end
