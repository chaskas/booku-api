class Booking < ApplicationRecord

  attribute :status_ids

  belongs_to :client
  belongs_to :place
  belongs_to :user

  has_many :payments, dependent: :destroy
  has_many :statements, dependent: :destroy
  has_many :statuses, through: :statements

  def pending
    self.total - Payment.where(booking_id: self.id).sum(:amount)
  end

end
