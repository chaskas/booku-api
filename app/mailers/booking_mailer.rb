class BookingMailer < ApplicationMailer

  require 'open-uri'

  def booking_confirmation_client(booking)
    @booking = booking


    @days = ((@booking.departure.to_date.at_beginning_of_day - @booking.arrival.to_date.at_beginning_of_day)/1.day).to_i + 1
    @nights = ((@booking.departure.to_date.at_beginning_of_day - @booking.arrival.to_date.at_beginning_of_day)/1.day).to_i

    @dsep = 0
    if @booking.statuses.detect{ |s| s.id == 2 }
      @dsep = @booking.place.dsep
    end

    @aditional_person = 0
    if (@booking.adults.to_i + @booking.childrens.to_i) > @booking.place.capacity.to_i
      @aditional_person = @booking.place.extra_passenger
    end

    attachments['Reserva_' + I18n.localize(@booking.arrival, format: '%Y%m%d') + '_' + @booking.id.to_s + '.pdf'] = open(url_for :controller => 'bookings', :action => 'show', :id => @booking.id, :format => 'pdf').read

    mail(to: %("#{@booking.client.first_name} #{@booking.client.last_name}" <#{@booking.client.email}>), subject: 'Confirmación de Reserva - Club de Campo Ainahue')
  end

  def booking_confirmation_business(booking)

    @booking = booking


    @days = ((@booking.departure.to_date.at_beginning_of_day - @booking.arrival.to_date.at_beginning_of_day)/1.day).to_i + 1
    @nights = ((@booking.departure.to_date.at_beginning_of_day - @booking.arrival.to_date.at_beginning_of_day)/1.day).to_i

    @dsep = 0
    if @booking.statuses.detect{ |s| s.id == 2 }
      @dsep = @booking.place.dsep
    end

    @aditional_person = 0
    if (@booking.adults.to_i + @booking.childrens.to_i) > @booking.place.capacity.to_i
      @aditional_person = @booking.place.extra_passenger
    end

    puts

    attachments['Reserva_' + I18n.localize(@booking.arrival, format: '%Y%m%d') + '_' + @booking.id.to_s + '.pdf'] = open(url_for :controller => 'bookings', :action => 'show', :id => @booking.id, :format => 'pdf').read

    mail(to:  %("Contacto Ainahue" <rodrigo@webdevel.cl>), subject: 'Nueva Reserva - Club de Campo Ainahue')

  end

end
