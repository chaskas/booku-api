class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :update, :destroy]

  # GET /payments
  def index
    @payments = Payment.all

    render json: @payments
  end

  # GET /payments/b/1
  def get_payments_by_booking_id
    @payments = Payment.where(booking_id: params[:id]).order('created_at ASC')

    render json: @payments
  end

  # GET /payments/1
  def show
    render json: @payment
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)

    if @payment.save

      if @payment.booking.payments.count < 2
        BookingMailer.booking_confirmation_client(@payment.booking).deliver_now
        BookingMailer.booking_confirmation_business(@payment.booking).deliver_now
      end

      render json: @payment, status: :created, location: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payments/1
  def update
    if @payment.update(payment_params)
      render json: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payments/1
  def destroy
    @payment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payment_params
      params.require(:payment).permit(:amount, :method, :bill, :booking_id)
    end
end
