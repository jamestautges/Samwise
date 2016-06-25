module.exports = (robot) ->
	
	robot.respond /I\'m not [attending|coming to] the next Tuesday meeting/i, (res) ->
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
			nextmeeting.setDate(currdate+2-currday)
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
			
	robot.respond /I'm [attending|coming to] the next Tuesday meeting/i, (res) ->
		person = "attendance:" + res.message.user.name
		attendance = robot.brain.get(person)
		currday = new Date
		if attendance?
			recorded = new Date(attendance)
			if recorded.getTime() < currday.getTime()
				res.send "I already have you attending the next meeting, #{res.message.user.name}"
			else
				robot.brain.set person, "0"
				res.send "I have registered that you will be attending the next meeting, #{res.message.user.name}"
		else
			res.send "I already have you attending the next meeting, #{res.message.user.name}"