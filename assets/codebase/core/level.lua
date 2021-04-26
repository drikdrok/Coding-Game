Level = class("Level")

function Level:initialize()

	self.environment = {}

	self.reference = {}

	self.name = "Unnamed"

	self.objectiveWindow = window:new(10, 10, 10, 10)

	self.testScore = 0
	self.requiredScore = 0

end

function Level:update(dt)

end

function Level:draw()

end

function Level:winCondition()

end

function Level:restart()
end


function loadLevel(l)
	return require("levels/"..l)
end