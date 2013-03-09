class Kase < ActiveRecord::Base
  attr_accessible :name, :new_id, :old_id, :response, :transfer_id, :xml
  include TransferExtension

=begin
<kase>
  <id type="integer">1</id>
  <author-id type="integer"></author-id>
  <closed-at type="datetime"></closed-at>
  <created-at type="datetime"></created-at>
  <updated-at type="datetime">2007-03-19T22:34:22Z</updated-at>
  <name>A very important matter</name>
  <visible-to>Everyone</visible-to>
  <group-id type="integer"></group-id>
  <owner-id type="integer"></owner-id>
  <parties type="array">
    <party>...</party>
  </parties>
</kase>
=end

  def target_url
    "#{self.transfer.target_url}/kases.xml"
  end

  def target_form(original)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.kase {
        xml.name x(original.name)
        xml.send(:'visible-to', original.visible_to)
      }
    end
    builder.doc.root.to_xml
  end

  def get_id(response)
   self.load_credentials('target')
   new_id = Highrise::Kase.find_by_name(x(self.name)).try(:id)  
  end
end
