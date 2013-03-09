class Note < ActiveRecord::Base
  attr_accessible :body, :new_id, :old_id, :response, :transfer_id, :xml
end
