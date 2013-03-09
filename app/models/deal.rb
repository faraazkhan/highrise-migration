class Deal < ActiveRecord::Base
  attr_accessible :name, :new_id, :old_id, :response, :transfer_id, :xml
  serialize :parties, Hash
  include TransferExtension 
=begin

------ Target XML Format---------
  <deal>
  <name>#{name}</name>

  <!-- optional fields -->
  <party-id type="integer">#{party_id}</party-id>
  <visible-to>Everyone</visible-to>
  <group-id type="integer">#{group_id}</group-id>
  <owner-id type="integer">#{owner_id}</owner-id>
  <responsible-party-id type="integer">#{responsible_party_id}</responsible-party-id>
  <category-id type="integer">#{category_id}</category-id>
  <background>#{background}</background>
  <currency>#{currency}</currency>
  <price type="integer">#{price}</price>
  <price-type>fixed</price-type>
  <duration type="integer">#{duration}</duration>
</deal>
--------END---------------------
=end

  def target_url
    "#{self.transfer.target_url}/deals.xml"
  end

  def target_form(original)


    builder = Nokogiri::XML::Builder.new do |xml|
      xml.deal {
        xml.name x(original.name)
        xml.send(:'party-id', new_party_id(original.party_id)) if new_party_id(original.party_id)
        xml.background x(original.background)
        xml.send(:'visible-to', original.visible_to)
        xml.send(:'responsible-party-id', new_user_id(original.responsible_party_id)) if new_user_id(original.responsible_party_id)
        xml.send(:'category-id', new_category_id(original.category_id)) if new_category_id(original.category_id)
        xml.price original.price
        xml.send(:'price-type', original.price_type)
        xml.duration original.duration
        xml.currency original.currency
        xml.status original.status
      }
    end
 
    builder.doc.root.to_xml
  end

  #TODO:
  #Who's Involved


  #def tag_url
    #"#{self.target_base_url}/deals/#{self.new_id}/tags.xml" if self.new_id.present?
  #end

  #def apply_tags
    #url = self.tag_url
    #self.tag.keys.each do |key|
      #response = self.post_record(self.target_key, url, self.tag[key])
    #end

  #end

  #def build_tags_from(original)
    #if original.tags
      #i= 1
      #hash = {}
      #original.tags.each do |t|
        #builder = Nokogiri::XML::Builder.new do |xml|
          #xml.name t['name']
        #end
        #hash["tag_#{i}"] = builder.doc.root.to_xml
        #i = i+1
      #end
    #end
    #hash
  #end

  def new_party_id(old_id)
    party_person = self.transfer.people.find_by_old_id(old_id).try(:new_id) 
    party_company = self.transfer.companies.find_by_old_id(old_id).try(:new_id)
    new_party_id = party_person || party_company
  end

  def new_category_id(old_id)
    new_id = self.transfer.deal_categories.find_by_old_id(old_id).try(:new_id)
  end

  def new_user_id(old_id)
    unless old_id.nil?
      user = self.transfer.users.where("old_id = #{old_id}").try(:first)
      id = user.try(:new_id) rescue nil
      id
    end
  end

  
end

