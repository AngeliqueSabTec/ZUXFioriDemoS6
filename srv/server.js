const cds = require('@sap/cds')

// In the cloud, send the bare app URL straight to the Fiori app
// (locally, keep the default CAP welcome page)
if (process.env.NODE_ENV === 'production') {
  cds.on('bootstrap', app => app.get('/', (_, res) => res.redirect('/flightsop/webapp/index.html')))
}

module.exports = cds.server
