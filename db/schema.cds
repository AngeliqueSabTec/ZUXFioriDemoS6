namespace sap.fe.demo.flight;

using { cuid, managed } from '@sap/cds/common';

entity Flights : cuid, managed {
  carrierID     : String(3)    @title: 'Carrier';
  connectionID  : String(4)    @title: 'Connection';
  flightDate    : Date         @title: 'Flight Date';
  price         : Decimal(9,2) @title: 'Price';
  currency_code : String(3)    @title: 'Currency' default 'USD';
  plannedSeats  : Integer      @title: 'Planned Seats';
  bookedSeats   : Integer      @title: 'Booked Seats';
  seatsMax         : Integer     @title: 'Planned Seats';
  seatsOcc         : Integer     @title: 'Booked Seats';


  // Calculated element — CAP's equivalent of a CASE WHEN
  // column in an ABAP CDS interface view
  priceCriticality : Integer = case
    when price <= 500  then 3   // green
    when price <= 1000 then 2   // amber
    else 1                      // red
  end;

  // Field control for Price: 3 = Optional, 1 = ReadOnly
  priceFieldControl : Integer = case
    when bookedSeats < plannedSeats then 3   // seats still available
    else 1                                    // fully booked, closed
  end;

    // Calculated elements — same logic as your RAP CASE WHEN columns
  seatsAvailable   : Integer = seatsMax - seatsOcc
                      @readonly @Core.Computed: true @title: 'Seats Available';

  isFullyBooked : Boolean = bookedSeats >= plannedSeats;
  bookings      : Composition of many Bookings on bookings.flight = $self;
}

entity Bookings : cuid, managed {
  flight                : Association to Flights;
  bookingID             : String(8)   @title: 'Booking ID';
  customerID            : String(6)   @title: 'Customer ID';
  custType              : String(1)   @title: 'Customer Type';
  smoker                : Boolean     @title: 'Smoker';
  bookingClass          : String(1)   @title: 'Class';
  foreignCurrencyAmount : Decimal(9,2) @title: 'Amount (Booking Currency)';
  foreignCurrencyKey    : String(3)    @title: 'Booking Currency';
  localCurrencyAmount   : Decimal(9,2) @title: 'Amount (Local Currency)';
  localCurrencyKey      : String(3)    @title: 'Local Currency';
  orderDate             : Date        @title: 'Order Date';
  passengerName         : String(25)  @title: 'Passenger Name';
  passengerForm         : String(15)  @title: 'Salutation';
  passengerBirthDate    : Date        @title: 'Date of Birth';
  cancelled             : Boolean     @title: 'Cancelled' default false;
}
