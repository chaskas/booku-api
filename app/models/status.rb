class Status < ApplicationRecord
  has_many :statements, dependent: :destroy
  has_many :bookings, through: :statements
end
