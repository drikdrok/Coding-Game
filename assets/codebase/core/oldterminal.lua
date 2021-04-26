terminal = class("terminal")

function terminal:initialize()
	self.line = 1
	self.col = 0
	self.lines = {""}

	self.cursor = true
	self.cursorTimer = 0

	self.typing = true
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

	for i,v in pairs(self.lines) do
		love.graphics.setColor(0.8,0.8,0.8)
		love.graphics.print(i, 6, 28*i + 25)
		love.graphics.setColor(1,1,1)


		local text = ""

		for word in string.gmatch(v, "[^%s]+") do
   			text = self:colorCodeWords(text, word)
		end

		text = self:colorCodeLine(text)

		local indention = 0
		for i = 0, v:len() do  -- Dirty hack because the richtext library removes initial whitespaces and I can't stop it
			if v:sub(i+1, i+1) ~= " " then break end
			indention = indention + 1
		end

		local finalText = rt:new( {text, 10000000, textRules}, {1,1,1})
		finalText:draw(25 + indention * game.font:getWidth(" "), 28*i + 25)
	end
	if self.cursor and self.typing then 
		love.graphics.line(game.font:getWidth(self.lines[self.line]:sub(1, self.col)) + 40, self.line * 28 + 25, game.font:getWidth(self.lines[self.line]:sub(1, self.col)) + 40, self.line * 28 + 50)
	end
end


function terminal:textinput(input)
	if self.typing then 
		self:write(input:gsub("@", ""):gsub("£", ""))
	end
end

function terminal:keypressed(key)
	if self.typing then 
		if key == "backspace" then 
			local left = self.lines[self.line]:sub(1, self.col - 1)
			local right = self.lines[self.line]:sub(self.col+1, #self.lines[self.line])
			if self.col >= 1 then 
				self.col = self.col - 1
				self.lines[self.line] = left .. right
			else
				if #self.lines >1 then 
					local line = self.lines[self.line]
					table.remove(self.lines, self.line)
					self.line = self.line - 1
					self.col = self.lines[self.line]:len()
					self.lines[self.line] = self.lines[self.line] .. line
				end
			end
		elseif key == "tab" then 
			self:write("    ")
		elseif key == "return" then 

			table.insert(self.lines, self.line+1, "")
			self.lines[self.line + 1] = self.lines[self.line]:sub(self.col+1, self.lines[self.line]:len())
			self.lines[self.line] = self.lines[self.line]:sub(1, self.col)

			self.line = self.line + 1
			self.col = 0

		elseif key == "up" then 
			self.line = self.line - 1
		elseif key == "down" then 
			self.line = self.line + 1
		elseif key == "left" then 
			self.col = self.col - 1
		elseif key == "right" then 
			self.col = self.col + 1
		end	

		if self.line < 1 then 
			self.line = 1
		elseif self.line > #self.lines then
			self.line = #self.lines
		end
		if self.col > #self.lines[self.line] then 
			self.col = #self.lines[self.line]
		elseif self.col < 0 then 
			self.col = 0
		end


		if love.keyboard.isDown("lctrl") then 

			if love.keyboard.isDown("b") then 
				game.running = true
				game.currentLevel:restart()
			elseif love.keyboard.isDown("t") and game.running then 
				game.running = false
				console:write("Program Terminated")
			elseif love.keyboard.isDown("v") then 
				self:write(love.system.getClipboardText())
			end
		end
	end
end

function terminal:write(input)
	local left = self.lines[self.line]:sub(1, self.col)
	local right = self.lines[self.line]:sub(self.col + 1, #self.lines[self.line])
	self.lines[self.line] = left .. input .. right
	self.col = self.col + #input
end

function terminal:colorCodeWords(text, word)

	local initialWord = word

	if coloredWords[word] then 
		word = "£"..coloredWords[word].."@"..word
	elseif tonumber(word) ~= nil then 
		word = "£digit@"..word
	end


	if word ~= initialWord then 
		word = word.."£white@"
	end

	return text .. " " .. word
end

function terminal:colorCodeLine(line)
	--Color strings: ""
	local indices = {}
	local i = 0
	while true do 
		i = line:find('"', i+1)
		if i == nil then break end
		table.insert(indices, i)

	end

	local increment = 0

	for i,v in pairs(indices) do
		if i % 2 == 1 then 
			line = line:sub(1, v + increment) .. "£string@" .. line:sub(v + increment+1)
			increment = increment + 8
		else
			line = line:sub(1, v + increment+1) .. "£white@" .. line:sub(v + increment+2)
			increment = increment + 7
		end
	end	

	return line

end

function terminal:compile()
	local finalString = ""
	for i, line in pairs(self.lines) do
		finalString = finalString .. "\n"..line
	end

	jit.off() -- LuaJIT disables quotas for the sandbox library. This works long-term hopefully

	local environment = {print = function(str) console:write(str) end, exit = function() game.running = false; console:write("Program Terminated Successfully") end, clear = function() console:clear() end,}

	local ok, result = pcall(sandbox.run, finalString, {env = createEnvironment(environment, game.currentLevel.environment)})

	if not ok then
		result = tostring(result) 
		if result:find('...]:') then 
			console:write("Error on line "..result:sub(result:find('...]:') + 5))
		elseif result:find("159:") then 
			console:write(result:sub(result:find("159:")+4))
		end
		game.running = false
		console:write("Program Terminated Due To Error")
	end

	jit.on()
end

function terminal:clear()
	self.lines = {""}
	self.line = 1
	self.col = 0
end	


function removeInitialSpaces(s)
	while s:sub(1, 1) == " " do
		s = s:sub(2)
	end
	return s
end

function createEnvironment(e1, e2) -- Merge the table for the universal envrionment and the environment of the current level
	for key, v in pairs(e2) do
		e1[key] = v
	end

	return e1
end

