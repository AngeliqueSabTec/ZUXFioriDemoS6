sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"sap/fe/demo/flightsop/test/integration/pages/FlightsList.gen",
	"sap/fe/demo/flightsop/test/integration/pages/FlightsObjectPage.gen"
], function (JourneyRunner, FlightsListGenerated, FlightsObjectPageGenerated) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('sap/fe/demo/flightsop') + '/test/flp.html#app-preview',
        pages: {
			onTheFlightsListGenerated: FlightsListGenerated,
			onTheFlightsObjectPageGenerated: FlightsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

