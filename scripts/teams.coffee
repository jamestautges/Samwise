module.exports = (robot) ->
            
    robot.respond /I\'m (leading|heading|organizing) the (.*) team/i, (res) ->
        res.send "Thanks for heading the #{res.match[2]} team #{res.message.user.name}"
        robot.brain.set res.match[2], res.message.user.name
        
    robot.respond /Who[ is']* (leading|heading|organizing) the (.*) team/i, (res) ->
        team = res.match[2]
        leader = robot.brain.get(team)
        if leader?
            res.send "#{leader} is leading the #{team} team"
        else
            res.send "No one is leading that team at the moment. Would you like to?"