GoogleSpreadsheet = require 'google-spreadsheet'
Conversation = require 'hubot-conversation'

# Spreadsheet key
doc = new GoogleSpreadsheet '1nAs4V7Dob68muSdjjVSGsyk46xlg4sWB1GoYl582nCM'

# Rows to search in the sheet
rowsInSheet = 3

module.exports = (robot) ->
	
	getUsersByNames = (names) ->
		allUsers = robot.brain.users()
		users = []
		for key of allUsers
			user = allUsers[key]
			robot.logger.info user
			if user.real_name in names
				users.push user
		users
	
	switchBoard = new Conversation robot
	
	robot.respond /How do (I|you) (.*)\?/i, (res) ->
		request = res.match[2]
		# Request the first sheet from the google sheet
		doc.getRows 1, offset: 1, limit: rowsInSheet, orderby: 'A', reverse: false, query: false, (err, rows) ->
			# Iterate over rows. If a match is found for the task, respond with the protocol and possible mentors/student leaders
			found = false
			for key of rows
				row = rows[key]
				if row.task.toLowerCase() == request.toLowerCase()
					found = true
					res.reply "#{row.protocol}\nYou might want to consult #{row.student} and #{row.mentor}.\nWould you like me to contact them?"
					students = [row.student, row.mentor]
					
					# Offer contact with the experts listed in the sheet
					dialog = switchBoard.startDialog res
					dialog.addChoice /Yes/i, (res2) ->
						res2.reply "Ok. I'll tell them you're interested."
						users = getUsersByNames students
						robot.logger.info students
						robot.logger.info users
						for user in users
							robot.logger.info user.name
							robot.send room: user.name, "Hey. #{res2.message.user.real_name} wanted to know how to #{request}. Can you help them out?"
						
					dialog.addChoice /(No|Nope)/i, (res2) ->
						res2.reply "Alright. But if you change your mind, either ask me again or talk to them yourself."
						
			# If we can't find the task in the sheet, forward them to a human
			if !found
				res.reply "I don't know how to #{request}. You should probably ask a real human."