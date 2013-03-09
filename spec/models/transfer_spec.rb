require 'spec_helper'

describe Transfer do
  context "Validations" do
    [:source_api_token, :target_api_token, :source_url, :target_url].each do |required_field|
      it { should validate_presence_of(required_field) }
    end
  end
end
