class MigrationAssistant
  @queue = :migration

  def self.perform(transfer_id, class_name)
    @transfer = Transfer.find(transfer_id)
    case class_name
    when 'company' then
      self.import_companies
    when 'person' then
      import_people
    when 'deal' then
      import_deals
    when 'deal_category' then
      import_deal_categories
    #when 'task_category' then 
      #import_task_categories
    #when 'user' then
      #import_users
    when 'kase' then
      import_cases
    #when 'note' then
      #import_notes
    when 'task'
      import_tasks
    end
  end

  def self.load_credentials
    Highrise::Base.site = @transfer.source_url
    Highrise::Base.user = @transfer.source_api_token
    Highrise::Base.format = :xml
  end

  def self.import_companies
    return nil
    self.load_credentials
    #companies = [Highrise::Company.last]
    companies = Highrise::Company.find_all_across_pages(:params => {:id => ''})
    companies.each do |com|
      c = @transfer.companies.new
      c.migrate(com, 'Highrise::Company')
    end
  end

  def self.import_people
    self.load_credentials
    #people = [Highrise::Person.find(72328632)]
    people = Highrise::Person.find_all_across_pages(:params => {:id => ''})
    people.each do |person|
      p = @transfer.people.new
      p.migrate(person, 'Highrise::Person')
    end
  end

  def self.import_deal_categories
    self.load_credentials
    #categories = [Highrise::DealCategory.last]
    categories = Highrise::DealCategory.all
    categories.each do |cat|
      c = @transfer.deal_categories.new
      c.migrate(cat, 'Highrise::DealCategory')
    end
  end

  def import_task_categories
    #self.load_credentials
    ##categories = [Highrise::TaskCategory.last]
    #categories = Highrise::TaskCategory.all
    #categories.each do |cat|
      #c = @transfer.deal_categories.new
      #c.migrate(cat, 'Highrise::TaskCategory')
    #end
  end

  def self.import_users
    #self.load_credentials
    #users = [Highrise::User.first]
    #users = Highrise::User.all
    #user.each do |user|
      #u = @transfer.users.new
      #u.migrate(user, "Highrise::User")
    #end
  end

  def self.import_deals
    self.load_credentials
    #deals = [Highrise::Deal.first]
    deals = Highrise::Deal.all
    deals.each do |deal|
      d = @transfer.deals.new
      d.migrate(deal, "Highrise::Deal")
    end
  end

  def self.import_notes
    #notes = Highrise::Note.find_all_across_pages(:params => {:id => ''})
    #notes.each do |note|
      #n = @transfer.notes.new
      #n.migrate(note.id)
    #end
  end

  def self.import_cases
    self.load_credentials
    cases = Highrise::Kase.all
    cases.each do |kase|
      c = @transfer.kases.new
      c.migrate(kase, "Highrise::Kase")
    end
  end

  def self.import_tasks
    tasks = Highrise::Task.find_all_across_pages(:params => {:id => ''})
    tasks.each do |task|
      t = @transfer.tasks.new
      t.migrate(task.id)
    end
  end


end
