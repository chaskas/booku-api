class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :capacity, :price, :extra_night, :extra_passenger, :dsep, :display_order, :created_at, :updated_at, :ptype, :ptype_id
end
