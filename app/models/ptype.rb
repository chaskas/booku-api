class Ptype < ApplicationRecord
  has_many :places, dependent: :nullify
end
