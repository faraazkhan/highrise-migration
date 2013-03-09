require 'rexml/document'
require 'rest_client'
class Company < ActiveRecord::Base
  include TransferExtension
  attr_accessible :name, :new_id, :old_id, :xml, :tag, :response
  serialize :tag, Hash

=begin 

-----Target XML Format------
<company>
  <name>Doe Inc.</name>
  <background>A popular company for random data</background>
  <visible-to>Owner</visible-to>
  <contact-data>
    <email-addresses>
      <email-address>
        <address>corporate@example.com</address>
        <location>Work</location>
      </email-address>
    </email-addresses>
    <phone-numbers>
      <phone-number>
        <number>555-555-5555</number>
        <location>Work</location>
      </phone-number>
      <phone-number>
        <number>555-666-6667</number>
        <location>Fax</location>
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
</company>
-------END-----------

=end

  def target_url
    "#{self.transfer.target_url}/companies.xml"
  end

   def target_form(original)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.company {
        xml.name x(original.name) if original.name
        xml.background x(original.background) if original.background
        xml.send(:'visible-to', original.visible_to)
        xml.send(:'contact-data'){
          # Format email addresses
          if original.contact_data.email_addresses.present?
            xml.send(:'email-addresses') {
              original.contact_data.email_addresses.each do |email|
                xml.send(:'email-address', email)
              end
            }
          end
          # Format phone numbers
          if original.contact_data.phone_numbers.present?
            xml.send(:'phone-numbers') {
              original.contact_data.phone_numbers.each do |num|
                xml.number num.number
                xml.location num.location
              end
            }
          end
        }
      }
    end
    builder.doc.root.to_xml
  end

   def tag_url
    "#{self.target_base_url}/companies/#{self.new_id}/tags.xml" if self.new_id.present?
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
