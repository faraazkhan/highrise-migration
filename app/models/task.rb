class Task < ActiveRecord::Base
  attr_accessible :name, :new_id, :old_id, :response, :transfer_id, :xml
  include TransferExtension
=begin
------------TARGET XML------------
<task>
  <body>A timed task for the future</body>
  <frame>specific</frame>
  <due-at type="datetime">2007-03-10T15:11:52Z</due-at>
  <category-id>1</category-id>

  <!-- optional -->
  <subject-type>#{Party|Company|Kase|Deal}</subject-type>
  <subject-id>#{associated_subject.id}</subject-id>
  <category-id type="integer">#{task_category.id}</category-id>
  <recording-id type="integer">#{associated_recording.id}</recording-id>
  <owner-id type="integer">#{owner_user.id}</owner-id>
  <public type="boolean">#{true|false}</public>
  <notify type="boolean">#{true|false}</notify>
</task>
--------END------------------
=end


  def target_url
    "#{self.transfer.target_url}/tasks.xml"
  end

  def target_form(original)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.task {
        xml.body x(original.body)
        xml.frame x(original.frame)
        xml.send(:'due-at', x(original.due-at))
        xml.send(:'category-id', new_category_id(original.category_id))
        xml.send(:'subject-type', original.subject_type)
        xml.send(:'subject-id', new_subject_id(original.subject_id, original.subject_type))
        xml.send(:'owner-id', new_user_id(original.owner_id))
        xml.public original.public
        xml.notify original.notify
        xml.send(:'recording-id', new_recording_id(original.recording_id))
      }
    end
    builder.doc.root.to_xml
  end

  def new_category_id(old_id)
    new_id = TaskCategory.find_by_old_id(old_id).try(:new_id)
  end

  def new_subject_id(old_id, subject_type)
    self.load_credentials
    klass = "Highrise::#{subject_type}".constantize
    name = klass.find(old_id).try(:name)
    self.load_credentials('target')
    new_id = klass.find_by_name(name).try(:id)
  end

  def new_user_id(old_id)
    unless old_id.blank?
      user = self.transfer.users.where("old_id = #{old_id}").try(:first)
      id = user.try(:new_id) rescue nil
      id
    end
  end

  def new_recording_id(old_id, recording_type)
    if recording_type == Note
      self.load_credentials
      note = Highrise::Note.find(old_id)
      self.load_credentials('target')
      new_id = Highrise::Note.find_by_body(x(note.body)).try(:id)
    end
  end
end
