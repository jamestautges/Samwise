GoogleSpreadsheet = require 'google-spreadsheet'
async = require 'async'

doc = new GoogleSpreadsheet '1nAs4V7Dob68muSdjjVSGsyk46xlg4sWB1GoYl582nCM'

creds = require './Samwise-1f970b13a403.json'

doc.getRows 1, offset: 1, limit: 2, orderby: 'A', reverse: false, query: false, (err, rows) ->
    console.log err
    console.log rows