menu = class("menu")

function menu:initialize()
	self.buttons = {
		button:new("Start", 5, 5, function() -- Return to menu button
			self.startWindow.visible = not self.startWindow.visible
			game.suspendWindows = true
		end),

		button:new("Objective: 0/0", 100, 5, function()
			if game.currentLevel.name ~= "start" then 
				game.currentLevel.objectiveWindow.visible = true
			end
		end)
	}

	self.fileState = "save"

	self.startWindow = window:new(2, 35, 150, 200, true)
	self.startWindow:addButton(button:new("Home", 5, 5, function()
		game:loadLevel("start")
		self.startWindow.visible = false
	end))

	self.startWindow:addButton(button:new("Save As", 5, 40, function()
		self.saveWindow.visible = not self.saveWindow.visible
		game.suspendWindows = true
		self.fileState = "save"
	end))

	self.startWindow:addButton(button:new("Open Save", 5, 75, function()
		self.saveWindow.visible = not self.saveWindow.visible
		game.suspendWindows = true
		self.fileState = "open"
	end))


	self.saveWindow = window:new(160, 35, 100, 150, true)
	self.saveWindow:addButton(button:new("Save1", 5, 5, function()
		if self.fileState == "save" then 
			game:saveFile("Save1")
		else
			game:openFile("Save1")
		end
		self.saveWindow.visible = not self.saveWindow.visible
	end))
	self.saveWindow:addButton(button:new("Save2", 5, 50, function()
		if self.fileState == "save" then 
			game:saveFile("Save2")
		else
			game:openFile("Save2")
		end
		self.saveWindow.visible = not self.saveWindow.visible
	end))
	self.saveWindow:addButton(button:new("Save3", 5, 95, function()
		if self.fileState == "save" then 
			game:saveFile("Save3")
		else
			game:openFile("Save3")
		end
		self.saveWindow.visible = not self.saveWindow.visible
	end))
end

function menu:update(dt)
	if game.currentLevel.name ~= "start" then 
		self.buttons[2]:setText("Objective: "..game.currentLevel.testScore .. " / "..game.currentLevel.requiredScore)
	else
		self.buttons[2]:setText("")
	end

	local x, y = love.mouse.getPosition()
	for i,v in pairs(self.buttons) do
		v:update(x, y)
	end
end

function menu:draw()
	for i,v in pairs(self.buttons) do
		v:draw()
	end
end

function menu:mousepressed(x, y)
	for i,v in pairs(self.buttons) do
		v:click(x, y)
	end
end