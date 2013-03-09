class TaskCategory < ActiveRecord::Base
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
    "#{self.transfer.target_url}/task_categories.xml"
  end


  def target_form(original)

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.send(:'task-category') {
        xml.name x(original.name) if original.name
        xml.color original.color
      }
    end
 
    builder.doc.root.to_xml
  end

  def get_id(response)
    self.load_credentials('target')
    new_id = Highrise::TaskCategory.find_by_name(x(self.name)).try(:id)
  end

end
