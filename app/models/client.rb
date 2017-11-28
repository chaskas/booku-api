class Client < ApplicationRecord

  validates :rut, uniqueness: true

  has_many :bookings, dependent: :destroy
end
