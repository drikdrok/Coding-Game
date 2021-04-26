terminal = class("terminal")


local font, fontWidth, fontHeight
local editorBuffer, col, rows

function terminal:initialize()
	font = game:fontSize(20)
	fontWidth = font:getWidth(' ')
	fontHeight = font:getHeight()
	local width, height = love.graphics.getDimensions()
	cols = math.floor(width  / fontWidth)
	rows = math.floor(height / fontHeight) - 1
	self.editorBuffer = buffer.new(20, 29, drawToken, drawRectangle, "")

	self.cursor = true
	self.cursorTimer = 0
end

function terminal:update(dt)
	self.cursorTimer = self.cursorTimer + dt
	if self.cursorTimer >= 0.5 then 
		self.cursorTimer = 0
		self.cursor = not self.cursor
	end

	if game.running then 
		self:compile()
	end
end

function terminal:draw()
	self.editorBuffer:drawCode()
	love.graphics.setColor(1,1,1)
end


function terminal:compile()

	local lines = self.editorBuffer.lexed
	local finalString = ""
	for i,v in pairs(lines) do
		for j, k in pairs(v) do
			finalString = finalString .. k.data
		end
		finalString = finalString .. "\n"
	end

	jit.off() -- LuaJIT disables quotas for the sandbox library.

	local environment = { --Methods player has access to in game
		print = function(str) console:write(str) end, 
		exit = function() game.running = false; console:write("Program Terminated Successfully") end, 
		clear = function() console:clear() end, 
		input = function() return game.currentLevel.IOController:getInput() or nil end,
		output = function(out) 
			if game.currentLevel.IOController then 
				game.currentLevel.IOController:getOutput(out) 
			else 
				error("Level does not support output!") 
			end
		end,
	}

	local ok, result = pcall(sandbox.run, finalString, {quota = 5000000, env = createEnvironment(environment, game.currentLevel.environment)})

	if not ok then
		result = tostring(result) 
		if result:find('...]:') then 
			console:write("Error on line "..result:sub(result:find('...]:') + 5))
		elseif result:find("159:") then -- Quota exceeded
			console:write(result:sub(result:find("159:")+4))
		end
		game.running = false
		console:write("Program Terminated Due To Error")
		console:write(result)
	end

	jit.on()
end

function terminal:clear()
	if self.editorBuffer then 
		self.editorBuffer:setText("")
	end
end	


function createEnvironment(e1, e2) -- Merge the table for the universal envrionment and the environment of the current level
	for key, v in pairs(e2) do
		e1[key] = v
	end

	return e1
end


function drawToken(text, x, y, tokenType)
  local color = highlighting[tokenType] or {1,1,1}
  love.graphics.setFont(font)
  love.graphics.setColor(color)
  love.graphics.print(text, x,y)
end

function drawRectangle(col, row, width, tokenType)
  local color = highlighting[tokenType] or {1,1,1}
  local x =  col * fontWidth
  local y =  row * fontHeight + 5
  local width = width * fontWidth
  local height = fontHeight
  love.graphics.setColor(color)
  love.graphics.rectangle('fill', x, y, width+4, height + 10)
end

function terminal:keypressed(k)
  if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
    k = 'shift+'.. k
  end
  if love.keyboard.isDown('lalt') then
    k = 'alt+'.. k
  end
  if love.keyboard.isDown('ralt') then
    k = 'ralt+'.. k
  end
  if love.keyboard.isDown('lctrl') then
    if k == "b" then 
    	game.running = true
    	game.currentLevel:restart()
    	self:compile()
    elseif k == "t" then
    	game.running = false
    	console:write("Program Terminated")
    end
    k = 'ctrl+'.. k
  end 
  if keymapping.buffer[k] then
    local functionName = keymapping.buffer[k]
    self.editorBuffer[functionName](self.editorBuffer)
  end
  if keymapping.macros[k] then
    keymapping.macros[k]()
  end
end

function terminal:textinput(k)
    self.editorBuffer:insertCharacter(k:gsub('[\192-\255][\128-\191]*', '?'))
    self.cursor = true
    self.cursorTimer = 0
end
