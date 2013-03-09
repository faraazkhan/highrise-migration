class User < ActiveRecord::Base
  attr_accessible :email, :name, :new_id, :old_id, :response, :xml
  include TransferExtension
  scope :without_target_id, where('new_id is NULL')


  def target_url
    "#{self.transfer.target_url}/users.xml"
  end

  def target_form(original)


    builder = Nokogiri::XML::Builder.new do |xml|
      xml.deal {
        xml.name x(original.name)
        xml.send(:'email-address', original.email_address) if original.email_address 
      }
    end
 
    builder.doc.root.to_xml
  end

  def get_new_ids_from_target
    Highrise::Base.site = self.transfer.target_url
    Highrise::Base.site = self.transfer.target_api_token
    Highrise::Base.format = :xml
    self.transfer.users.each do |user|
      new_user = Highrise::User.find(:params => {:email => user.email}) rescue nil
      user.new_id = new_user.try(:id)
      user.save
    end
    
  end



end
