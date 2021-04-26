IOController = class("IOController")

function IOController:initialize(x, y, range, expected)

	self.x = x
	self.y = y

	self.range = range
	self.expected = expected
	self.output = {}

	self.step = 1

end

function IOController:update(dt)

end

function IOController:draw()
	love.graphics.setLineWidth(2)
	game:fontSize(14)

	love.graphics.print("Input", self.x + 5 + 75/2 - game:getWidth("Input")/2, self.y + 6)
	love.graphics.rectangle("line", self.x + 5, self.y + 25, 74, 740)

	love.graphics.print("Expected", self.x + 100 + 74/2 - game:getWidth("Expected")/2, self.y + 6)
	love.graphics.rectangle("line", self.x + 100, self.y + 25, 74, 740)

	love.graphics.print("Output", self.x + 195 + 74/2 - game:getWidth("Output")/2, self.y + 6)
	love.graphics.rectangle("line", self.x + 195, self.y + 25, 74, 740)

	for i = 1, 36 do 
		love.graphics.print(self.range[i], self.x + 5 + 74/2 - game:getWidth(self.range[i])/2, self.y + 20 + 20*i)
	end
	for i = 1, 36 do 
		local n = self.expected[i] or "??"
		love.graphics.print(n, self.x + 100 + 74/2 - game:getWidth(n)/2, self.y + 20 + 20*i)
	end
	for i = 1, 36 do 
		if self.output[i] then 
			love.graphics.print(self.output[i], self.x + 195 + 74/2 - game:getWidth(self.output[i])/2, self.y + 20 + 20*i)
		end
	end

	game:fontSize(20)
	love.graphics.setLineWidth(3)
end

function IOController:getInput()
	local n = self.range[self.step]
	self.step = self.step + 1
	return n
end

function IOController:getOutput(out)
	table.insert(self.output, out)

	if fib(#self.output, {1,1}) == self.output[#self.output] then
		game.currentLevel.testScore = game.currentLevel.testScore + 1
	end	
end

function IOController:reset()
	self.step = 1
	self.output = {}
end
