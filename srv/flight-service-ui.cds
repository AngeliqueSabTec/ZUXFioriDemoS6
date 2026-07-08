using { FlightService } from './flight-service';

annotate FlightService.Flights with @(
  UI.SelectionFields: [
    carrierID,
    connectionID
  ],
  Search.searchable: true
);

annotate FlightService.Flights with @(
  UI.LineItem: [
    { Value: carrierID },
    { $Type: 'UI.DataFieldWithIntentBasedNavigation',
      Value: connectionID,
      SemanticObject: 'Flight',
      Action: 'displayFactSheet' },
    { Value: flightDate },
    { Value: price, Criticality: priceCriticality },
    { Value: bookedSeats },
    { Value: plannedSeats },

    // BOUND action — needs a selected row
    { $Type: 'UI.DataFieldForAction',
      Action: 'FlightService.cancelFlight',
      Label: 'Cancel Flight' },

    // UNBOUND action — always available in the toolbar
    { $Type: 'UI.DataFieldForAction',
      Action: 'FlightService.openBookingWindow',
      Label: 'Open Booking Window' }
  ]
);

annotate FlightService.Flights with @(
  UI.HeaderInfo: {
    TypeName: 'Flight',
    TypeNamePlural: 'Flights',
    Title: { Value: connectionID },
    Description: { Value: carrierID }
  },
  UI.Facets: [{
    $Type: 'UI.ReferenceFacet',
    Label: 'Flight Details',
    Target: '@UI.FieldGroup#GeneralData'
  }],
  UI.FieldGroup #GeneralData: {
    Data: [
      { Value: flightDate },
      { Value: price, ![@Common.FieldControl]: priceFieldControl },
      { Value: currency_code },
      { Value: bookedSeats },
      { Value: plannedSeats }
    ]
  }
);

annotate FlightService.Flights with @(
  UI.SelectionPresentationVariant #Open: {
    Text: 'Open',
    SelectionVariant: {
      SelectOptions: [{ PropertyName: isFullyBooked,
        Ranges: [{ Sign: #I, Option: #EQ, Low: false }] }]
    },
    PresentationVariant: { Visualizations: ['@UI.LineItem'] }
  },
  UI.SelectionPresentationVariant #Closed: {
    Text: 'Closed',
    SelectionVariant: {
      SelectOptions: [{ PropertyName: isFullyBooked,
        Ranges: [{ Sign: #I, Option: #EQ, Low: true }] }]
    },
    PresentationVariant: { Visualizations: ['@UI.LineItem'] }
  }
);

annotate FlightService.Flights with {
  priceCriticality  @UI.Hidden: true;
  priceFieldControl @UI.Hidden: true;
  isFullyBooked     @UI.Hidden: true;
};
