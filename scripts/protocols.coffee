GoogleSpreadsheet = require 'google-spreadsheet'
async = require 'async'

doc = new GoogleSpreadsheet '1nAs4V7Dob68muSdjjVSGsyk46xlg4sWB1GoYl582nCM'

rowsInSheet = 3

module.exports = (robot) ->
	
	robot.respond /How do I (.*)\?/i, (res) ->
		# Request the first sheet from the google sheet
		doc.getRows 1, offset: 1, limit: rowsInSheet, orderby: 'A', reverse: false, query: false, (err, rows) ->
			# Iterate over rows. If a match is found for the task, respond with the protocol and possible mentors/student leaders
			for key of rows
				row = rows[key]
				if row.task.toLowerCase() == res.match[1].toLowerCase()
					res.send row.protocol
					res.send "You might want to consult #{row.student} and #{row.mentor}"