class Status < ApplicationRecord
  has_many :statements
  has_many :bookings, through: :statements
end
