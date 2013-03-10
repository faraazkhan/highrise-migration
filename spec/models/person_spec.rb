require 'spec_helper'

describe Person do
  context 'Target URL'  do
    let(:person) {FactoryGirl.build(:person, :transfer => FactoryGirl.build(:transfer))}
    let(:resource_location) { 'people.xml' }
    let(:target_url_regex) {/.*\/#{resource_location}/}
    it "should point to the correct resource" do
      company.target_url.should =~ target_url_regex
    end
    it "should point to the correct domain" do
      company.target_url.gsub("/#{resource_location}",'').should == company.transfer.target_url
    end
  end

  context 'target form', :focus do
    let(:person) { FactoryGirl.build(:person) }
    let(:transfer) { FactoryGirl.build(:transfer) }
    before(:all) do
      VCR.use_cassette 'highrise/person' do
        transfer.load_credentials
        @response = Highrise::Person.first
        @xml = person.target_form(@response)
      end
      @doc = Nokogiri::XML(@xml)
    end
    it "should have the correct node" do
      @doc.children.first.name.should eq('person')
    end
    attributes = %w[first-name last-name title company-name background linkedin-url visible-to]
    attributes.each do |a|
      it "should have the correct value for #{a}" do
        response = @response.send(a.gsub('-','_').to_sym)
        response = response.nil? ? '' : response
        @doc.xpath("//#{a}").text.should be_eql(response)
      end
      it "should have the #{a} attribute" do
        @doc.xpath("//#{a}").should_not be_nil
      end
    end
  end
end

