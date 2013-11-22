class Event < ActiveRecord::Base
  attr_accessible :name, :date, :time

  validates :name, :presence => true,
                   :length => {:maximum => 255}

  validates :date, :presence => true

  validates :time, :length => {:maximum => 255}

end
