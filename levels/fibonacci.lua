local Fibonacci = class("Fibonacci", Level)

function Fibonacci:initialize()
	Level.initialize(self)

	self.name = "Fibonacci"

	self.requiredScore = 400


	self.environment = {
	}

	self.reference = {
		{"input()", "Get next input"},
		{"output(n)", "Output number"}
	}

	self.objectiveWindow = window:new(1920 / 2 - 650 / 2, 1080 / 2 - 300/2, 650, 200, true)
	self.objectiveWindow.drawContent = function()
		love.graphics.print("Calculate the first 400 Fibonacci numbers", 650 / 2 - game.font:getWidth("Calculate the first 400 Fibonacci numbers") / 2, 20)
	end
	self.objectiveWindow.visible = true

	self.objectiveWindow:addButton(button:new("Ok", 650/2-game.font:getWidth("Ok"), 125, function()
		self.objectiveWindow.visible = false
		terminal.typing = true
	end))

	local range = {}
	for i = 1, 400 do
		table.insert(range, i)
	end
	self.IOController = IOController:new(10, 10, range, {1, 1, 2, 3, 5, 8, 13, 24, 34, 55, 89, 144, 233, 377, 610, 987, 1597})

end

function Fibonacci:update(dt)

end

function Fibonacci:draw()
	self.IOController:draw()
end	

function Fibonacci:restart()
	self.IOController:reset()
	self.testScore = 0
end

function fib(n, computed)
	if not computed[n] then 
		computed[n] = fib(n-1, computed) + fib(n-2, computed)
	end
	return computed[n]
end



return Fibonacci:new()