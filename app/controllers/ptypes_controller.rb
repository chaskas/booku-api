class PtypesController < ApplicationController
  before_action :set_ptype, only: [:show, :update, :destroy]

  # GET /ptypes
  def index
    @ptypes = Ptype.all

    render json: @ptypes, include: :places
  end

  # GET /ptypes/1
  def show
    render json: @ptype
  end

  # POST /ptypes
  def create
    @ptype = Ptype.new(ptype_params)

    if @ptype.save
      render json: @ptype, status: :created, location: @ptype
    else
      render json: @ptype.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ptypes/1
  def update
    if @ptype.update(ptype_params)
      render json: @ptype
    else
      render json: @ptype.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ptypes/1
  def destroy
    @ptype.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ptype
      @ptype = Ptype.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ptype_params
      params.require(:ptype).permit(:name, :plural)
    end
end
