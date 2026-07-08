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

  isFullyBooked : Boolean = bookedSeats >= plannedSeats;
}