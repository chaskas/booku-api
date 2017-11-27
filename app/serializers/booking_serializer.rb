class BookingSerializer < ActiveModel::Serializer
  attributes :id, :arrival, :departure, :adults, :childrens, :subtotal, :discount, :total, :pending, :notes, :status_ids, :created_at, :updated_at, :user_id, :client_id, :place_id

  belongs_to :client
  belongs_to :place
  belongs_to :user

  has_many :payments
  has_many :statements
  has_many :statuses

end
