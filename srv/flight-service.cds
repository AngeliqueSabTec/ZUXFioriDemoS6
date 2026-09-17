using { sap.fe.demo.flight as db } from '../db/schema';

@path: '/odata/v4/flight'
service FlightService {
  @odata.draft.enabled
  entity Flights as projection on db.Flights actions {
    action cancelFlight() returns Flights;   // BOUND
    
  };
    entity Bookings as projection on db.Bookings;   // NEW — explicit exposure

  action openBookingWindow(forDate: Date) returns String;  // UNBOUND
}

//Can also have the annotations in here, but best practice is to have them in a separate file, so that the service definition is clean and easy to read.
// annotate FlightService.Flights with @(
//   UI.SelectionFields: [ carrierID, connectionID ],
//   Search.searchable: true
// );