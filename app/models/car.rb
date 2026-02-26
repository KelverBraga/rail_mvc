class Car < ApplicationRecord
  validates :model, :year, :color, :price, presence: true
  validates :electric, :is_selling, inclusion: { in: [true, false] }
end