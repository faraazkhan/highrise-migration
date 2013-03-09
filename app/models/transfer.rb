require 'zip/zip'
class Transfer < ActiveRecord::Base
  attr_accessible :source_api_token, :source_url, :target_api_token, :target_url , :migrated_users
  validates_presence_of :source_api_token, :source_url, :target_api_token, :target_url
  has_many :people, :dependent => :destroy
  has_many :companies, :dependent => :destroy
  has_many :deal_categories, :dependent => :destroy
  has_many :task_categories, :dependent => :destroy
  has_many :deals, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :kases, :dependent => :destroy
  after_create :import_users
  after_save :continue_transfer


  def load_credentials(loc = 'source')
    Highrise::Base.site = self.send(:"#{loc}_url")
    Highrise::Base.user = self.send(:"#{loc}_api_token")
    Highrise::Base.format = :xml
  end

  def import_users
    self.load_credentials
    users = Highrise::User.all
    if users
      users.each do |user|
        u = self.users.new
        u.migrate(user, "Highrise::User")
      end
    end
  end


  def continue_transfer
    self.load_credentials('target')
    self.users.without_target_id.each do |user|
      user.update_attribute(:new_id, Highrise::User.find_by_email_address(user.email).try(:id))
    end
    self.migrated_users? ? self.perform : nil
  end

   
  def perform
    unless performed?
      %w[ company person deal deal_category task_category kase note task].each do |k|
      Resque.enqueue(MigrationAssistant, self.id, k)
      end
      self.update_attribute :performed, true
    end
  end
end
