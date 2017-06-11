fs = require "pn/fs"
svg2png = require "svg2png"
child_process = require "child_process"
exec = child_process.exec

module.exports = (robot) ->
  robot.hear ///#{robot.name}\s+shiba\s+(.*)///i, (msg) ->
    msg.http("https://github.com/users/alice02/contributions").get() (err, res, body) ->
      fs.writeFile "test.svg", body
      fs.readFile("test.svg")
      .then(svg2png)
      .then (buffer) ->
        filename = "dst.png"
        fs.writeFile filename, buffer
        channel = msg.message.user.room
        exec "curl -F file=@#{filename} -F channels=#{channel} -F token=#{process.env.HUBOT_SLACK_TOKEN} https://slack.com/api/files.upload", (err, stdout, stderr) ->
          console.log err
          console.log stdout
      .catch (error) ->
        console.log error
