require 'spec_helper'

describe Company do
  context 'Target URL'  do
    let(:company) {FactoryGirl.build(:company, :transfer => FactoryGirl.build(:transfer))}
    let(:resource_location) { 'companies.xml' }
    let(:target_url_regex) {/.*\/#{resource_location}/}
    it "should point to the correct resource" do
      company.target_url.should =~ target_url_regex
    end
    it "should point to the correct domain" do
      company.target_url.gsub("/#{resource_location}",'').should == company.transfer.target_url
    end
  end

  context 'target form' do
    let(:company) { FactoryGirl.build(:company) }
    let(:transfer) { FactoryGirl.build(:transfer) }
    before(:each) do
      VCR.use_cassette 'highrise/company' do
        transfer.load_credentials
        @response = Highrise::Company.first
        @xml = company.target_form(@response)
      end
      @doc = Nokogiri::XML(@xml)
    end
    it "should have the correct node" do
      @doc.children.first.name.should eq('company')
    end
    attributes = %w[name visible-to]
    attributes.each do |a|
      it "should have the correct value for #{a}" do
        @doc.xpath("//#{a}").text.should eq(@response.send(a.gsub('-','_').to_sym))
      end
      it "should have the #{a} attribute" do
        @doc.xpath("//#{a}").should_not be_nil
      end
    end
  end
end
