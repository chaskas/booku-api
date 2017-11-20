class BookingsController < ApplicationController

  before_action :set_booking, only: [:show, :update, :destroy]
  before_action :default_format_xml, only: :show
  before_action :authenticate_user!, only: [:create]

  include ActionView::Helpers::NumberHelper

  # GET /bookings
  def index
    @bookings = Booking.all

    render json: @bookings, include: :statuses
  end

  # POST /bookings/agenda/monthly
  def get_bookings_by_day_and_ptype

    ptype = Ptype.find(params[:ptype])

    places = Place.where(ptype_id: ptype.id).order('display_order ASC')

    ini = params[:day].to_datetime
    fin = params[:day].to_datetime + params[:ndays].to_i.days
    if(ptype.schedule_type == 1)
      fin = params[:day].to_datetime + params[:ndays].to_i.hours
    end

    @matrix = Array.new((fin - ini).to_i)  { Array.new }
    if(ptype.schedule_type == 1)
      @matrix = Array.new(((fin.to_time - ini.to_time) / 3600))  { Array.new }
    end

    date = ini

    @matrix.each do |fil|

      places.each do |place|

        booking = Booking.includes(:client).where('place_id' => place.id).where("arrival <= :date AND departure > :date", { date: date }).take

        if booking
          fil.push({ id: place.id, booking: booking, client: booking.client, statuses: booking.statuses, payments: booking.payments })
        else
          fil.push({ id: place.id, booking: 0 })
        end

      end

      if(ptype.schedule_type == 1)
        date = date + 1.hours
      else
        date = date + 1.days
      end

    end

    render json: @matrix
  end

  # GET /bookings/1
  def show

    respond_to do |format|
      format.json { render json: @booking }
      format.pdf do

        pdf = Prawn::Document.new(:margin => [10,20,10,20])

        pdf.image "#{Rails.root}/public/logo.png", :width => 120, :position => :center

        pdf.stroke_horizontal_rule
        pdf.move_down 10
        pdf.font_size 18
        pdf.text "Reserva: " + @booking.place.name, :align => :center
        pdf.move_down 1
        pdf.stroke_horizontal_rule

        pdf.move_down 10
        pdf.font_size 10

        pdf.table(
            [
              [ "<b>Nombre:</b>",    "#{@booking.client.first_name} #{@booking.client.last_name}", "<b>Marca:</b>",   "#{@booking.client.car_brand}"],
              [ "<b>Rut:</b>",       "#{@booking.client.rut}",                                     "<b>Modelo:</b>",  "#{@booking.client.car_model}"],
              [ "<b>Email:</b>",     "#{@booking.client.email}",                                   "<b>Color:</b>",   "#{@booking.client.car_color}"],
              [ "<b>Fono:</b>",      "#{@booking.client.phone}",                                   "<b>Patente:</b>", "#{@booking.client.car_license}"],
              [ "<b>Dirección:</b>", "#{@booking.client.address}",                                 "",         ""],
              [ "<b>Ciudad:</b>",    "#{@booking.client.city}",                                    "<b>Responsable:</b>",    "#{@booking.user.name}"]
            ]
          ) do |t|
            t.width = 540
            t.column_widths = [90,180,90,180]
            t.cells.border_width = 0
            t.cells.style(:height => 15, :inline_format => true, :padding => [0, 0, 0, 5] )
            t.before_rendering_page do |page|
              page.row(0).border_top_width = 0
              page.row(-1).border_bottom_width = 0
              page.column(0).border_left_width = 0
              page.column(-1).border_right_width = 0
            end
          end

        pdf.move_down 10
        pdf.stroke_horizontal_rule
        pdf.move_down 10

        aditional_person_value = 0
        if (@booking.adults.to_i + @booking.childrens.to_i) > @booking.place.capacity.to_i
          aditional_person_value = @booking.place.extra_passenger
        end

        dsep = 0
        if @booking.statuses.detect{ |s| s.id == 2 }
          dsep = @booking.place.dsep
        end

        days = ((@booking.departure.to_date.at_beginning_of_day - @booking.arrival.to_date.at_beginning_of_day)/1.day).to_i + 1
        nights = ((@booking.departure.to_date.at_beginning_of_day - @booking.arrival.to_date.at_beginning_of_day)/1.day).to_i

        schedule_types = ['Noche','Hora']

        total_days = ""
        total_days_title = ""
        total_nights = ""
        total_nights_title = "<b>Total Noches:</b>"
        extension_title = ""
        extension = ""
        transfer_title = ""
        transfer = ""
        aditional_person_title = ""
        aditional_person = ""
        if @booking.place.ptype.schedule_type == 0
          total_days_title = "<b>Total Días:</b>"
          total_days = "#{ days }"
          total_nights_title = "<b>Total Noches:</b>"
          extension_title = "<b>Extension:</b>"
          extension = n_to_c(dsep)
          transfer_title = "<b>Translado:</b>"
          transfer = n_to_c(0)
          aditional_person_title = "<b>Persona Adic.</b>"
          aditional_person = n_to_c(aditional_person_value)
        else
          nights = ((@booking.departure.to_time - @booking.arrival.to_time)/3600).to_i
        end

        pdf.table(
            [
              [ "<b>Día Llegada:</b>",   "#{I18n.localize(@booking.arrival, format: '%A %d/%m/%Y')}",    "<b>Hora Llegada:</b>",  "#{@booking.arrival.strftime('%H:%M')}"],
              [ "<b>Día Retiro:</b>",    "#{I18n.localize(@booking.departure, format: '%A %d/%m/%Y')}",  "<b>Hora Retiro:</b>",   "#{@booking.departure.strftime('%H:%M')}"],
              [ total_days_title,    total_days,                                                    "<b>Adultos:</b>",       "#{@booking.adults}"],
              [ total_nights_title,  "#{ nights }",                                                  "<b>Niños:</b>",         "#{@booking.childrens}"],
              [ "",                      "",                                                             "<b>Total Personas</b>", @booking.adults.to_i + @booking.childrens.to_i],
              [ "","","",""],
              [ "<b>Valor #{schedule_types[@booking.place.ptype.schedule_type]}:</b>",  n_to_c(@booking.place.price),                                   "<b>Subtotal:</b>",      n_to_c(@booking.subtotal)],
              [ extension_title,      extension,                                                     "<b>% Descto:</b>",      @booking.discount.to_s + " %"],
              [ transfer_title,      transfer,                                                     "<b>Descuento:</b>",     n_to_c(@booking.subtotal * @booking.discount / 100)],
              [ aditional_person_title,   aditional_person,                                                     "",               ""],
              ["","","",""]
            ]
          ) do |t|
            t.width = 540
            t.column_widths = [90,180,90,180]
            t.cells.style(:height => 15, :inline_format => true, :padding => [0, 0, 0, 5] )
            t.cells.border_width = 0
            t.before_rendering_page do |page|
              page.row(0).border_top_width = 0
              page.row(-1).border_bottom_width = 0
              page.column(0).border_left_width = 0
              page.column(-1).border_right_width = 0
            end
          end

          pdf.stroke_horizontal_rule
          pdf.move_down 10

          pdf.table(
              [
                [ "<b>Total a Pagar:</b>",   "<b>"+n_to_c(@booking.total)+"</b>"],
                [ "<b>Total Abonos:</b>",    n_to_c(@booking.payments.sum(:amount))],
                [ "<b>Saldo Pendiente:</b>", n_to_c(@booking.total.to_i - @booking.payments.sum(:amount).to_i )],
              ]
            ) do |t|
              t.width = 210
              t.column_widths = [120,90]
              t.cells.border_width = 0
              t.cells.style(:height => 20, :inline_format => true, :align => :right )
              t.position = :right
              t.cells.border_width = 0
              t.before_rendering_page do |page|
                page.row(0).border_top_width = 0
                page.row(-1).border_bottom_width = 0
                page.column(0).border_left_width = 0
                page.column(-1).border_right_width = 0
              end
            end

            pdf.move_down 12
            pdf.stroke_horizontal_rule


          # Detalle de Pagos
          # methods = [ "Transferencia", "Efectivo", "WebPay", "Cheque" ]
          # payments_rows = [["<b>Fecha</b>", "<b>Boleta / Factura</b>", "<b>Método de Pago</b>", "<b>Monto</b>"]]
          # @booking.payments.each do |payment|
          #   payments_rows.push([I18n.localize(payment.created_at, format: '%d/%m/%Y'), payment.bill, methods[payment.method], n_to_c(payment.amount)])
          # end
          #
          # pdf.table(
          #
          #       payments_rows
          #
          #   ) do |t|
          #     t.width = 540
          #     t.column_widths = [90,180,90,180]
          #     t.cells.border_width = 0
          #     t.cells.style(:height => 20, :inline_format => true, :align => :right )
          #     t.position = :right
          #     t.cells.border_width = 0
          #     t.before_rendering_page do |page|
          #       page.row(0).border_top_width = 0
          #       page.row(-1).border_bottom_width = 0
          #       page.column(0).border_left_width = 0
          #       page.column(-1).border_right_width = 0
          #     end
          #   end

          pdf.move_down 100

          pdf.table(
              [
                [ "______________________________",   "______________________________"],
                [ "<b>#{@booking.client.first_name} #{@booking.client.last_name}</b>",   "<b>Club de Campo</b>"],
                [ "<b>#{@booking.client.rut}</b>",   "<b>Ainahue</b>"],
                [ "Recibo Conforme", "Recibo Conforme"]
              ]
            ) do |t|
              t.width = 540
              t.column_widths = [270, 270]
              t.cells.border_width = 0
              t.cells.style(:height => 15, :inline_format => true, :align => :center, :padding => [0, 0, 0, 5] )
              t.position = :right
              t.cells.border_width = 0
              t.before_rendering_page do |page|
                page.row(0).border_top_width = 0
                page.row(-1).border_bottom_width = 0
                page.column(0).border_left_width = 0
                page.column(-1).border_right_width = 0
              end
            end

          pdf.move_down 55

          pdf.font_size 9
          pdf.text "HORARIOS DE ATENCIÓN", :align => :center
          pdf.text "Complejo Turístico: 10:00 a 19:00 Hrs.", :align => :center
          pdf.text "Restaurante: 10:00 a 19:00 Hrs.", :align => :center
          pdf.text "Administración: 10:00 a 19:00 Hrs", :align => :center
          pdf.text "Piscina Temperada de Lunes a Viernes 15:00 a 19:00 Hrs.", :align => :center
          pdf.text "Piscina Temperada de Sábado a Domingo 11:00 a 19:00 Hrs.", :align => :center

          pdf.move_down 10
          pdf.font_size 7
          pdf.text "NOTA: En caso de que requiera salir o entrar fuera del horario de funcionamiento del recinto, favor avisar a administración. NO SE PERMITE FIESTA EN LAS CABAÑAS", :align => :center
          pdf.text "Anibal Pinto 215, Of. 409, Concepción - www.ainahue.cl - 2247008 - 98840445 - ainahue@ainahue.cl - Avda. La Araucana 2202, Hualqui.", :align => :center
          pdf.text "NO SE ACEPTAN MASCOTAS - PISCINA TEMPERADA OBLIGATORIO USO DE GORRA", :align => :center
          pdf.text "Los abonos no son reembolsables en caso de desistimiento.", :align => :center

        send_data pdf.render,
          filename: "Reserva" + @booking.id.to_s + ".pdf",
          type: 'application/pdf',
          disposition: 'inline'
      end
    end



  end

  # POST /bookings
  def create
    if user_signed_in?

      @booking = Booking.new(booking_params)
      @booking.user = current_user

      if @booking.save
        render json: @booking, status: :created, location: @booking
      else
        render json: @booking.errors, status: :unprocessable_entity
      end

    else
      render status: :unauthorized
    end

  end

  # PATCH/PUT /bookings/1
  def update
    # if user_signed_in?
      if @booking.update(booking_params)
        render json: @booking
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    # else
    #   render status: :unauthorized
    # end
  end

  # DELETE /bookings/1
  def destroy
    # if user_signed_in?
      @booking.destroy
    # else
    #   render status: :unauthorized
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def booking_params
      params.require(:booking).permit(:arrival, :departure, :subtotal, :total, :discount, :adults, :childrens, :client_id, :place_id, :status_ids => [])
    end

    # Set format to xml unless client requires a specific format
    # Works on Rails 3.0.9
    def default_format_xml
      request.format = "json" unless params[:format]
    end

    def n_to_c (number)
      number_to_currency(number, unit: "$", separator: ",", delimiter: ".", precision: 0, format: "%u %n")
    end

end
