class MigrationAssistant
  include Sidekiq::Worker
  sidekiq_options queue: "migration"
  sidekiq_options retry: false
  sidekiq_options :failures => true

  def perform(transfer_id, class_name)
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
    when 'kase' then
      import_cases
    when 'task'
      import_tasks
    end
  end

  def load_credentials
    Highrise::Base.site = @transfer.source_url
    Highrise::Base.user = @transfer.source_api_token
    Highrise::Base.format = :xml
  end

  def import_companies
    self.load_credentials
    companies = Highrise::Company.find_all_across_pages(:params => {:id => ''})
    companies.each do |com|
      c = @transfer.companies.new
      c.migrate(com, 'Highrise::Company')
    end
  end

  def import_people
    self.load_credentials
    people = Highrise::Person.find_all_across_pages(:params => {:id => ''})
    people.each do |person|
      p = @transfer.people.new
      p.migrate(person, 'Highrise::Person')
    end
  end

  def import_deal_categories
    self.load_credentials
    categories = Highrise::DealCategory.all
    categories.each do |cat|
      c = @transfer.deal_categories.new
      c.migrate(cat, 'Highrise::DealCategory')
    end
  end

  def import_deals
    self.load_credentials
    deals = Highrise::Deal.all
    deals.each do |deal|
      d = @transfer.deals.new
      d.migrate(deal, "Highrise::Deal")
    end
  end


  def import_cases
    self.load_credentials
    cases = Highrise::Kase.all
    cases.each do |kase|
      c = @transfer.kases.new
      c.migrate(kase, "Highrise::Kase")
    end
  end

  def import_tasks
    tasks = Highrise::Task.find_all_across_pages(:params => {:id => ''})
    tasks.each do |task|
      t = @transfer.tasks.new
      t.migrate(task.id)
    end
  end


end
