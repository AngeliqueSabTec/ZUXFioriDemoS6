const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  const { Flights,Bookings } = this.entities;

  // Validation — same job as req.error() everywhere in CAP,
  // equivalent to RAP's IF ... IS INITIAL + NEW_MESSAGE_WITH_TEXT
  this.before(['CREATE', 'UPDATE'], Flights, (req) => {
    if (req.data.bookedSeats > req.data.plannedSeats) {
      req.error(400, 'Booked seats cannot exceed planned seats');
    }
    // const { seatsMax, seatsOcc } = req.data;
    // if (seatsOcc != null && seatsMax != null && seatsOcc > seatsMax) {
    //   req.error(400, 'Booked seats cannot exceed planned seats');
    // }
  });

   // Same check when a Booking is added directly under a Flight
  this.before(['CREATE', 'UPDATE'], Bookings, async (req) => {
    const { carrierID, connectionID, flightDate } = req.data;
    const flight = await SELECT.one.from(Flights, { carrierID, connectionID, flightDate });
    if (flight && flight.seatsOcc + 1 > flight.seatsMax) {
      req.error(400, 'This flight is already fully booked');
    }
  });

  // BOUND action — acts on the single selected Flights record
  this.on('cancelFlight', Flights, async (req) => {
    const flight = req.params[0];
    await UPDATE(Flights, flight.ID).with({ plannedSeats: flight.bookedSeats });
    return await SELECT.one.from(Flights, flight.ID);
  });

  // UNBOUND action — independent, no row selection
  this.on('openBookingWindow', async (req) => {
    const { forDate } = req.data;
    await UPDATE(Flights).set({ bookedSeats: 0 }).where({ flightDate: forDate });
    return `Booking window opened for flights on ${forDate}`;
  });
});