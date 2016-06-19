module.exports = (robot) ->
	
	robot.respond /I\'m not attending the next Tuesday meeting/i, (res) ->
		person = "attendance:" + res.message.user.name
		nextmeeting = new Date
		currday = nextmeeting.getDay()
		currdate = nextmeeting.getDate()
		# Set nextmeeting to the following Tuesday
		if currday == 2
			if hour >= 19
				nextmeeting.setDate(currdate+7)
			else
				nextmeeting.setDate(currdate)
		else if currday <=1
			nextmeeting.setDate(2-currday)
		else
			nextmeeting.setDate(currdate+7-currday+2)
		newstring = nextmeeting.toDateString()
		attendance = robot.brain.get(person)
		if attendance?
			last = new Date(attendance)
			if last.getTime() < nextmeeting.getTime()
				robot.brain.set person, newstring
				res.send "Thanks for letting me know that you'll miss the next meeting (on #{newstring}), #{res.message.user.name}"
			else
				res.send "I already have you marked down as missing the next meeting (on #{newstring}), #{res.message.user.name}"
		else
			robot.brain.set person, newstring
			res.send "Thanks for letting me know that you'll miss the next meeting (on #{newstring}), #{res.message.user.name}"