class DealCategory < ActiveRecord::Base
  attr_accessible :name, :new_id, :old_id, :xml, :response
  include TransferExtension

=begin 

-----Target XML Format------
<#{type}-category>
  <name>#{name}</name>
  <color>#{hex-color}</color>
</#{type}-category>
-------END-----------

=end

  def target_url
    "#{self.transfer.target_url}/deal_categories.xml"
  end


  def target_form(original)

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.send(:'deal-category') {
        xml.name x(original.name) if original.name
        xml.color original.color
      }
    end
    builder.doc.root.to_xml
  end

  def get_id(response)
    #since we know the response for deal categories is always nil
    self.load_credentials('target')
    new_id = Highrise::DealCategory.find_by_name(x(self.name)).try(:id)
  end


end
