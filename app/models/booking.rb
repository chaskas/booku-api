class Booking < ApplicationRecord

  attribute :status_ids

  belongs_to :client
  belongs_to :place
  belongs_to :user

  has_many :payments
  has_many :statements
  has_many :statuses, through: :statements

  def as_json(options={})
    options[:methods] = [:pending]
    super
  end

  def pending
    self.total - Payment.where(booking_id: self.id).sum(:amount)
  end

end
