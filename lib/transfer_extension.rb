module TransferExtension

  def self.included(base)
    base.belongs_to :transfer
  end

  def load_credentials(loc = 'source')
    Highrise::Base.site = self.transfer.send(:"#{loc}_url")
    Highrise::Base.user = self.transfer.send(:"#{loc}_api_token")
    Highrise::Base.format = :xml
  end

  def target_base_url
    self.transfer.target_url  rescue nil
  end

  def target_key
    self.transfer.target_api_token rescue nil
  end


  def migrate(object, highrise_class)
    if object.is_a?(highrise_class.constantize)
      begin
        self.import(object)
        self.new_id = get_id(post_record(target_key, target_url, xml)) rescue nil
        self.save
        self.apply_tags if self.respond_to?(:apply_tags)
        self.attach_notes(object) if self.respond_to?(:notes)
      rescue
      end
    end
  end

  def import(record)
    @original = record
    self.old_id = @original.id
    self.name = @original.name if self.respond_to?(:name)
    self.first_name = @original.first_name if self.respond_to?(:first_name)
    self.last_name = @original.last_name if self.respond_to?(:last_name)
    self.tag = build_tags_from(@original) if self.respond_to?(:tag) && !@original.is_a?(Highrise::Deal)
    self.xml = self.target_form(@original) if self.respond_to?(:xml)
    self.company_id = @original.company_id if self.respond_to?(:company_id)
    self.email = @original.email_address if self.respond_to?(:email)
    self.note = @original.attach_notes if self.respond_to?(:note)
    self.save
  end

   def post_record(key, url, xml)
     begin
      self.response = RestClient::Request.new(
                    :method => :post,
                    :payload => xml, 
                    :url => url, 
                    :user => key, 
                    :headers => { :content_type => 'application/xml'}
                    ).execute
     rescue
     end
  end


  def print_xml(arg = self.xml)
    doc = REXML::Document.new arg
    out = ''
    doc.write(out,1)
    puts out
  end

  def get_id(xml)
    begin
    x = Nokogiri::XML(xml)
    doc = x.root
    doc.at_xpath('id').text.to_i 
    rescue
    end
  end
  
  def x(string)
    string = string.try(:to_s) unless string.is_a?(String)
    Builder::XChar.encode(string) rescue nil
  end

  def attach_notes(object)
    begin
      if object.respond_to?(:notes) && self.new_id
        url = "#{self.transfer.target_url}/notes.xml"
        notes = object.notes
        notes.each do |note|
          post_record(self.transfer.target_api_token, url, target_xml_for_note(note)) if target_xml_for_note(note)
        end
      end
    rescue
    end
  end

  def target_xml_for_note(note)
    begin
     builder = Nokogiri::XML::Builder.new do |xml|
      xml.note {
        xml.body x("Note originally created by: #{source_user_name(note.author_id)} \n #{note.body}")
        xml.send(:'subject-id',new_subject_id(note.subject_id, note.subject_type)) 
        xml.send(:'subject-type', note.subject_type)
        xml.send(:'collection-id', new_subject_id(note.collection_id, note.collection_type))
        xml.send(:'collection-type', note.collection_type)
        xml.send(:'author-id', new_user_id(note.author_id))
        xml.send(:'created-at', note.created_at)

      }
    end
    builder.doc.root.to_xml
    rescue
    end
  end

  def new_subject_id(id, subject_type)
    if subject_type == 'Party'
      new_subject = self.transfer.people.find_by_old_id(id) || self.companies.find_by_old_id(id)
    end

    if subject_type == 'Deal'
      new_subject = self.transfer.deals.find_by_old_id(id)
    end

    if subject_type == 'Kase'
      new_subject = self.transfer.kases.find_by_old_id(id)
    end

    new_subject.new_id if new_subject
  end

  def new_user_id(id)
    self.transfer.users.find_by_old_id(id).try(:new_id)
  end

  def source_user_name(id)
    self.transfer.load_credentials
    name = Highrise::User.find(id).try(:name)
  end

end
