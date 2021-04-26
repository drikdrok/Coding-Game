local Fruits = class("Fruits", Level)

function Fruits:initialize()
	Level.initialize(self)

	self.name = "fruits"


	self.requiredScore = 10

	self.rect = {
		x = 100,
		y = 100,
		width = 32,
		height = 32
	}

	self.fruit = {
		x = math.random(140, 760),
		y = math.random(140, 760),
		width = 16,
		height = 16,
	}

	self.bot = {
		move = function(x, y) self.rect.x = self.rect.x + x; self.rect.y = self.rect.y + y end,
		getPosition = function() return self.rect.x, self.rect.y end,
		getX = function() return self.rect.x end,
		getY = function() return self.rect.y end,
	}

	self.fruitCommands = {
		getPosition = function() return self.fruit.x, self.fruit.y end
	}	

	self.environment = {
		bot = self.bot,
		fruit = self.fruitCommands,
	}

	self.reference = {
		{"bot.move(x, y)", "Move bot x pixels horizontally and y pixels vertically"},
		{"bot.getPosition()", "Gets bot's coordinates"},
		{"fruit.getPosition()", "Gets fruit's coordinates"},
	}

	self.objectiveWindow = window:new(1920 / 2 - 650 / 2, 1080 / 2 - 300/2, 650, 200)
	self.objectiveWindow.drawContent = function()
		love.graphics.print("Collect 10 fruits with the bot to complete", 650 / 2 - game.font:getWidth("Collect 10 fruits with the bot to complete") / 2, 20)
	end
	self.objectiveWindow.visible = true

	self.objectiveWindow:addButton(button:new("Ok", 650/2-game.font:getWidth("Ok"), 125, function()
		self.objectiveWindow.visible = false
		terminal.typing = true
	end))

end

function Fruits:update(dt)
	if self.rect.x + self.rect.width >= self.fruit.x and self.rect.x < self.fruit.x + self.fruit.width and self.rect.y + self.rect.height >= self.fruit.y and self.rect.y < self.fruit.y + self.fruit.height then 
		self.fruit.x = math.random(10, 780)
		self.fruit.y = math.random(10, 780)

		self.testScore = self.testScore + 1
	end 
end

function Fruits:draw()
	love.graphics.setColor(1,0,0)

	love.graphics.rectangle("fill", self.rect.x, self.rect.y, self.rect.width, self.rect.height)

	love.graphics.setColor(0,1,0)


	love.graphics.rectangle("fill", self.fruit.x, self.fruit.y, self.fruit.width, self.fruit.height)

	love.graphics.setColor(1,1,1)

	game:fontSize(30)

	love.graphics.print(self.testScore, 400 - game.font:getWidth(self.testScore) / 2, 20)

	game:fontSize(20)
end	

function Fruits:restart()
	self.fruit.x = math.random(10, 780)
	self.fruit.y = math.random(10, 780)

	self.rect.x = 100
	self.rect.y = 100
end



return Fruits:new()