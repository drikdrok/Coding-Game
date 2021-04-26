button = class("button")

function button:initialize(text, x, y, onClick)
	self.x = x
	self.y = y
	
	self:setText(text)

	self.onClick = onClick

	self.mouseOver = false

end

function button:update(x, y)
	if rectangleCollision(x, y, 1, 1, self.x, self.y, self.width, self.height) then 
		self.mouseOver = true
	else
		self.mouseOver = false
	end
end

function button:draw()
	if self.mouseOver then
		love.graphics.setColor(0.8, 0.8, 0.8)
	end
	love.graphics.print(self.text, self.x, self.y)
	love.graphics.setColor(1,1,1)
end

function button:setText(text) 
	self.text = text

	self.width = love.graphics.getFont():getWidth(self.text)
	self.height = love.graphics.getFont():getHeight(self.text)
end

function button:click(x, y)
	if self.mouseOver then
		self:onClick()
		self.mouseOver = false
	end
end