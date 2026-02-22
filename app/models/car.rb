class Car < ApplicationRecord
  validates_presence_of :model, :year, :color, :electric, :is_selling
end
#class Car < ApplicationRecord
#  validates :model, :year, :color, presence: true
#  validates :electric, :is_selling, inclusion: { in: [true, false] }
#end