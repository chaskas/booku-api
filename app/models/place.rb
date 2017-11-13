class Place < ApplicationRecord
  
  belongs_to :ptype

  before_save :set_order

  has_many :bookings, dependent: :nullify

  private
    def set_order

      last_place = Place.where(ptype_id: self.ptype_id).order('display_order ASC').last

      if last_place

        self.display_order = last_place.display_order + 1

      else

        self.display_order = 0

      end

    end
end
