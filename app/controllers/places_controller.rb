class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :update, :destroy]

  # GET /places
  def index
    @places = Place.order('display_order ASC')

    render json: @places, include: :ptype
  end

  # GET /places/ptype/1
  def get_places_by_ptype

    @places = Place.where(ptype_id: params[:ptype]).order('display_order ASC')
    render json: @places

  end

  # GET /places/1
  def show
    render json: @place, include: :ptype
  end

  # POST /places
  def create
    @place = Place.new(place_params)

    if @place.save
      render json: @place, status: :created, location: @place
    else
      render json: @place.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /places/1
  def update
    if @place.update(place_params)
      render json: @place
    else
      render json: @place.errors, status: :unprocessable_entity
    end
  end

  # DELETE /places/1
  def destroy
    @place.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def place_params
      params.require(:place).permit(:name, :ptype_id, :capacity, :price, :opening, :closing, :extra_night, :extra_passenger, :dsep)
    end
end
