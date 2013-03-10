class Person < ActiveRecord::Base
  attr_accessible :company_id, :first_name, :last_name, :new_id, :old_id, :tag, :xml, :response
  serialize :tag, Hash
  include TransferExtension
  #SOURCE_KEY = 'cf40826f62c4c5e2d795db9bd7110523'
  #SOURCE_SITE = 'https://sevarapartners.highrisehq.com'

  #TARGET_KEY = 'cc16568f88a8dacd24bd55c483423b3f'
  #TARGET_SITE = 'https://rationalizeit.highrisehq.com/people.xml'
  #TARGET_BASE =  'https://rationalizeit.highrisehq.com'

=begin 

-----Target XML Format------
<person>
  <first-name>John</first-name>
  <last-name>Doe</last-name>
  <title>CEO</title>
  <company-name>Doe Inc.</company-name>
  <background>A popular guy for random data</background>
  <linkedin_url>http://us.linkedin.com/in/john-doe</linkedin_url>
  <contact-data>
    <email-addresses>
      <email-address>
        <address>john.doe@example.com</address>
        <location>Work</location>
      </email-address>
    </email-addresses>
    <phone-numbers>
      <phone-number>
        <number>555-555-5555</number>
        <location>Work</location>
      </phone-number>
      <phone-number>
        <number>555-666-6666</number>
        <location>Home</location>
      </phone-number>
    </phone-numbers>
  </contact-data>
  <!-- custom fields -->
  <subject_datas type="array">
    <subject_data>
      <value>Chicago</value>
      <subject_field_id type="integer">2</subject_field_id>
    </subject_data>
  </subject_datas>
</person>
-------END-----------

=end


  def target_url
    "#{self.transfer.target_url}/people.xml"
  end

  def target_form(original)

  

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.person {
        xml.send(:'first-name', x(original.first_name) ) if original.first_name
        xml.send(:'last-name', x(original.last_name) ) if original.last_name
        xml.title x(original.title)
        xml.send(:'company-name', x(original.company_name)) if original.company_name
        xml.background x(original.background) if original.background
        xml.send(:'linkedin-url',  x(original.linkedin_url))
        xml.send(:'visible-to', original.visible_to)
        xml.send(:'contact-data'){
          # Format email addresses
          if original.contact_data.email_addresses.present?
            xml.send(:'email-addresses') {
              original.contact_data.email_addresses.each do |email|
                xml.send(:'email-address') {
                  xml.send(:'address', email.address)
                  xml.send(:'location', email.location)
                }
              end
            }
          end
          # Format phone numbers
          if original.contact_data.phone_numbers.present?
            xml.send(:'phone-numbers') {
              original.contact_data.phone_numbers.each do |num|
                xml.send(:'phone-number') {
                  xml.number num.number
                  xml.location num.location
                }
              end
            }
          end
           if original.contact_data.addresses.present?
            xml.send(:'addresses') {
              original.contact_data.addresses.each do |add|
                xml.address {
                  xml.city x(add.city) if add.city
                  xml.country x(add.country) if add.country
                  xml.location x(add.location) if add.location
                  xml.state x(add.state) if add.state
                  xml.street x(add.street) if add.street
                  xml.zip x(add.zip) if add.zip
                }
              end
            }
          end

        }
      }
    end

    builder.doc.root.to_xml
  end


  def tag_url
    "#{self.target_base_url}/people/#{self.new_id}/tags.xml" if self.new_id.present?
  end

  def apply_tags
    url = self.tag_url
    self.tag.keys.each do |key|
      response = self.post_record(self.target_key, url, self.tag[key])
    end

  end

  def build_tags_from(original)
    if original.tags
      i= 1
      hash = {}
      original.tags.each do |t|
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.name t['name']
        end
        hash["tag_#{i}"] = builder.doc.root.to_xml
        i = i+1
      end
    end
    hash
  end



end
