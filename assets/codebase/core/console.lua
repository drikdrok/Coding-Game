console = class("console")

function console:initialize()
	self.lines = {}

	self.currentLine = 1

	self.y = 870 
end

function console:draw()
	horizontalLine(0, self.y, 68)
	love.graphics.print("Console", 5, self.y + 30)

	--for i = 1, #self.lines do
	--	love.graphics.print(self.lines[#self.lines - (i-1)], 5, self.y + 40 + i*28)
	--end

	for i = 1, 5 do
		if self.currentLine + i < #self.lines then 
			love.graphics.print(self.lines[self.currentLine + i], 5, self.y + 40 + i*28)
		end
	end	
end

function console:write(input)
	if #self.lines > 1000 then 
		self:clear()
		self.currentLine = self.currentLine - 1000
	end

	if type(input) == "string" or type(input) == "table" or type(input) == "number" or type(input) == "boolean" then 
		table.insert(self.lines, tostring(input))
		if #self.lines > 7 then 
			self.currentLine = self.currentLine + 1
		end
	end
end

function console:clear()
	self.lines = {}
end

function console:wheelmoved(y)
	if y > 0 then 
		self.currentLine = self.currentLine - 1
	elseif y < 0 then 
		self.currentLine = self.currentLine + 1
	end

	if self.currentLine < 1 then 
		self.currentLine = 1
	elseif self.currentLine > #self.lines-2 then 
		self.currentLine = #self.lines-2
	end
end		