local Flappy = class("Flappy", Level)

function Flappy:initialize()
	Level.initialize(self)

	self.name = "flappy"

	self.requiredScore = 20

	self.objectiveWindow = window:new(1920 / 2 - 650 / 2, 1080 / 2 - 300/2, 650, 200)
	self.objectiveWindow.drawContent = function()
		love.graphics.print("Clear 20 pipes to complete", 650 / 2 - game.font:getWidth("Clear 20 pipes to complete") / 2, 20)
	end
	self.objectiveWindow.visible = true

	self.objectiveWindow:addButton(button:new("Ok", 650/2-game.font:getWidth("Ok"), 125, function()
		self.objectiveWindow.visible = false
		terminal.typing = true
	end))



	self.b = {
		flap = function() if self.flapCooldown <= 0 then self.bird.yvel = -600; self.flapCooldown = 0.5 end end,
		getY = function() return self.bird.y end,
	}

	self.p = {
		getX = function() return self.nearest[1] end,
		getHeight = function() return self.nearest[2] end
	}	

	self.environment = {
		bird = self.b,
		pipe = self.p,
	}

	self.reference = {
		{"bird.flap()", "Flap wings"},
		{"bird.getY()", "Gets birds's Y-coordinate"},
		{"pipe.getX()", "Returns nearest pipe's X-coordinate"},
		{"pipe.getHeight()", "Returns nearest top pipe's height"},
	}






	self.bird = {
		x = 100,
		y = 100,
		yvel = 0,
		width = 32,
		height = 32
	}

	self.flapCooldown = 0

	self.gravity = 1500

	self.pipes = {{600, math.random(100, 700), false}}
	self.pipeSpeed = 320

	self.nearest = self.pipes[1]

end

function Flappy:update(dt)

	self.bird.yvel = self.bird.yvel + self.gravity * dt
	self.bird.y = self.bird.y + self.bird.yvel * dt

	self.flapCooldown = self.flapCooldown - dt

	for i,v in pairs(self.pipes) do
		v[1] = v[1] - self.pipeSpeed*dt

		if v[1] <= self.bird.x - 25 and v[3] == false then  -- Pass bird
			v[3] = true
			self.testScore = self.testScore + 1
			table.insert(self.pipes, {900, math.random(100, 700), false})
			self.nearest = self.pipes[#self.pipes]
		elseif v[1] < -75 then
			self.pipes[i] = nil
		end	


		-- Bird collide with pipeSpeed
		if rectangleCollision(self.bird.x, self.bird.y, self.bird.width, self.bird.height, v[1], 0, 50, v[2]) or rectangleCollision(self.bird.x, self.bird.y, self.bird.width, self.bird.height, v[1], v[2] + 200, 50 , 800) then
			game.running = false
			console:write("Program Terminated: Bird died!")
		end  
	end

end

function Flappy:draw()
	love.graphics.setColor(1, 1, 0)
	love.graphics.rectangle("fill", self.bird.x, self.bird.y, self.bird.width, self.bird.height)
	love.graphics.setColor(1, 1, 1)

	love.graphics.setColor(0.2, 1, 0.1)
	for i, v in pairs(self.pipes) do

		love.graphics.rectangle("fill", v[1], 0, 50, v[2])
		love.graphics.rectangle("fill", v[1], v[2] + 200, 50 , 800)

	end
	love.graphics.setColor(1,1,1)


	game:fontSize(30)

	love.graphics.print(self.testScore, 400 - game.font:getWidth(self.testScore) / 2, 20)

	game:fontSize(20)
end	

function Flappy:restart()
	self.bird = {
		x = 100,
		y = 100,
		yvel = 0,
		width = 32,
		height = 32
	}

	self.pipes = {{600, math.random(100, 700), false}}

	self.testScore = 0
	self.nearest = self.pipes[1]
end



return Flappy:new()