class Statement < ApplicationRecord
  belongs_to :booking
  belongs_to :status
end
