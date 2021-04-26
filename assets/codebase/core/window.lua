window = class("window")

local windows = {}

function window:initialize(x, y, width, height, closeOnClickOutside)
	self.x = x
	self.y = y	


	self.width = width
	self.height = height

	self.closeOnClickOutside = closeOnClickOutside or false

	self.visible = false

	self.buttons = {}

	table.insert(windows, self)
end

function window:update(dt)
	local x, y = love.mouse.getPosition()
	for i, v in pairs(self.buttons) do
		v:update(x - self.x, y - self.y)
	end
end

function window:draw()
	love.graphics.push()
	love.graphics.translate(self.x, self.y)


	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, self.width, self.height)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line", 0, 0, self.width, self.height)

	--horizontalLine(0, 0, self.width/game.font:getWidth("-"))
	--horizontalLine(0, self.height, self.width/game.font:getWidth("-"))
	--verticalLine(0, 0, self.height/game.font:getHeight("|"))
	--verticalLine(self.width, 0, self.height/game.font:getHeight("|"))


	self:drawContent()

	for i,v in pairs(self.buttons) do
		v:draw()
	end

	love.graphics.pop()
end

function window:drawContent()

end

function window:addButton(b)

	table.insert(self.buttons, b)
end

function windowsOnClick(x, y)
	for i,v in pairs(windows) do
		if v.visible then 
			for j, k in pairs(v.buttons) do
				k:click(x - v.x, y - v.y)
			end

			if v.closeOnClickOutside and not (x > v.x and x < v.x + v.width and y > v.y and y < v.y + v.height) then -- Mousepress outside active window
				if not game.suspendWindows then 
					v.visible = false
				end
			end
		end
	end
end

function drawAllWindows()
	for i,v in pairs(windows) do
		if v.visible then 
			v:draw()
		end
	end
end

function updateAllWindows(dt)
	for i,v in pairs(windows) do
		if v.visible then 
			v:update(dt)
		end
	end
end