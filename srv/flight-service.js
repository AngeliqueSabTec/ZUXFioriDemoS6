const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  const { Flights } = this.entities;

  // Validation — same job as req.error() everywhere in CAP,
  // equivalent to RAP's IF ... IS INITIAL + NEW_MESSAGE_WITH_TEXT
  this.before(['CREATE', 'UPDATE'], Flights, (req) => {
    if (req.data.bookedSeats > req.data.plannedSeats) {
      req.error(400, 'Booked seats cannot exceed planned seats');
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