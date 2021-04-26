game = class("game")

function game:initialize()
	self.fonts = {}
	self:fontSize(20)

	self.currentLevel = nil

	self.running = false

	self.suspendWindows = false

	--Create missing savefiles

	if not love.filesystem.getInfo("saves") then 
		love.filesystem.createDirectory("saves")
	end
	local levels = love.filesystem.getDirectoryItems("levels")
	for i,v in pairs(levels) do
		local n = v:gsub(".lua", "")
		if not love.filesystem.getInfo("levels/"..n) then 
			love.filesystem.createDirectory("saves/"..n)
		end
		for j=1, 3 do
			if not love.filesystem.getInfo("saves/"..n.."/Save"..j..".lua") then 
				local f = love.filesystem.newFile("saves/"..n.."/Save"..j..".lua")
				local m, err = f:open("w")
				f:close()
			end
		end
	end

end

function game:update(dt)
	terminal:update(dt)
	menu:update()

	if self.running then 
		self.currentLevel:update(dt)
	end

	if self.suspendWindows then 
		self.suspendWindows = false
	end

	updateAllWindows(dt)
end	

function game:draw()


	love.graphics.push()
	love.graphics.translate(1100, 0)
	
	self.currentLevel:draw()
	love.graphics.pop()

	--Black Background
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, 1100, 821)
	love.graphics.rectangle("fill", 0, 821, 1920, 1920-821)

	terminal:draw()
	console:draw()


	verticalLine(1100, 0, 55)
	horizontalLine(1100, 820, 60)
	love.graphics.print("Reference", 1120, 845)
	for i,v in pairs(self.currentLevel.reference) do
		love.graphics.print(v[1], 1120, 875 + i*25)
		love.graphics.print(v[2], 1400, 875 + i*25)
	end		

	--self.currentLevel.objectiveWindow:draw()
	drawAllWindows()

	menu:draw()

end

function game:loadLevel(level)
	self.running = false
	local ok, result = pcall(require, "levels/"..level)
	if ok then 
		self.currentLevel = result
		terminal:clear()

		console:clear()

		if self.currentLevel.name ~= "start" then -- Start level is unique 
			terminal.typing = false
			self.currentLevel.objectiveWindow.visible = true
		else
			terminal.editorBuffer:setText('--Start a level using start(). E.g. start("fruits") \n--Run your program by hitting CTRL + B\n--Terminate your program with CTRL + T or ESCAPE \n start("turret")')
			terminal.editorBuffer:cursorDown()
			terminal.editorBuffer:cursorDown()
			terminal.editorBuffer:cursorDown()
			terminal.editorBuffer:deselect()
		end

		self.currentLevel:restart()
	else
		console:write("Error: Level ".. '"'..level..'"'.." not found!")
	end
end	

function game:keypressed(key)
	if key == "escape" then 
		if self.currentLevel.objectiveWindow.visible then 
			self.currentLevel.objectiveWindow.visible = false
			terminal.typing = true
		elseif self.running then 
			self.running = false
			console:write("Program Terminated")
		elseif self.currentLevel.name == "start" then 
			love.event.quit()
		end	

	end
end

function game:mousepressed(x, y, b)
	if b == 1 then
		windowsOnClick(x, y)

		menu:mousepressed(x, y)
	end
end

function game:fontSize(size)
	if self.fonts[size] then 
		self.font = self.fonts[size]
	else
		self.font = love.graphics.newFont("assets/gfx/fonts/pixelmix.ttf", size)
		self.fonts[size] = self.font
	end
	love.graphics.setFont(self.font)
	return self.font
end	


function game:saveFile(file)
	local sucess, message = love.filesystem.write("saves/"..self.currentLevel.name.."/"..file..".lua", terminal.editorBuffer:getText())
	if not sucess then 
		console:write(message)
	end
end

function game:openFile(file)
	local contents, err = love.filesystem.read("saves/"..self.currentLevel.name.."/"..file..".lua")
	terminal.editorBuffer:setText(contents)
end	



function game:getWidth(str)
	return math.floor(self.font:getWidth(str))
end

function verticalLine(x, y, amount)
	for i = 0, amount do
		love.graphics.print("|", x, y + i*21)
	end
end

function horizontalLine(x, y, amount)
	local line = ""
	for i = 0, amount do
		line = line .. "-"
	end
	love.graphics.print(line, x, y)
end


function rectangleCollision(x1, y1, w1, h1, x2, y2, w2, h2) 
	return x1 >= x2 and x1 <= x2 + w2 and y1 >= y2 and y1 <= y2 + h2 
end