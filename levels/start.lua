Start = class("Start", Level)

function Start:initialize()
	Level.initialize(self)

	self.name = "start"

	self.showCredits = false

	self.environment = {
		start = function(level) 
			if not level then 
				console:write("Error: Argument must be a string!")
				game.running = false
			else
				game:loadLevel(string.lower(level)) 
			end
		end,
		credits = function() self.showCredits = not self.showCredits; game.running = false end,
		close = function() love.event.quit() end,
	}

	self.reference = {
		{"start(level)", "Starts specified level"},
		{"credits()", "Game credits"},
		{"close()", "Exit game"},
	}
end

function Start:update(dt)

end

function Start:draw()
	love.graphics.print("Available Levels:", 15, 15)
	love.graphics.print("fruits", 15, 50)
	love.graphics.print("fibonacci", 15, 80)
	love.graphics.print("flappy", 15, 110)
	love.graphics.print("turret", 15, 140)

	if self.showCredits then 
		love.graphics.print("Made by Christian Schwenger 2021", 15, 500)
	end

end


return Start:new()